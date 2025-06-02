//
//  EmotionInput.swift
//  DrawMe.
//
//  Created by Shannon Sie Santosa on 1/9/2024.
//

import SwiftUI
import FirebaseAuth

struct EmotionInput: View {
    @State var sessionId: String = ""
    @State var emotionDetails: String = ""
    
    @State private var redirect = false
    @Binding var inputEmotion: Bool
    @State var emotionValue: CGFloat = 0
    @State var emotionStrength: CGFloat = 0
    @EnvironmentObject var dataManager: DataManager
    
    @State private var errorMessage: String? = nil
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button("< Back") {
                        inputEmotion = false
                    }
                    .padding()
                    .padding(.horizontal)
                    .font(.custom("Poppins-Regular", size: geometry.size.width > 500 ? 24 : 16))
                    Spacer()
                }
                .navigationTitle("Emotion Input")
                
                ScrollView {
                    VStack {
                        VStack {
                            Text("Take a moment to think how you feel today, what emotions that you’ve been experienced, and answer the following questions:")
                                .font(.custom("Poppins-Regular", size: geometry.size.width > 500 ? 20 : 16))
                                .fontWeight(.semibold)
                            
                            VStack {
                                Text("Overall, how positive or negative are these feelings? \n(from 1: very negative to 7: very positive)")
                                    .font(.custom("Poppins-Regular", size: geometry.size.width > 500 ? 16 : 12))
                                    .multilineTextAlignment(.center)
                                
                                Slider(value: $emotionValue, in: 1...7, step: 1) {
                                    Text("Value")
                                } minimumValueLabel: {
                                    Text("1")
                                } maximumValueLabel: {
                                    Text("7")
                                }
                                .padding(.horizontal)
                                
                                Text("\(Int(emotionValue))")
                            }
                            .padding(geometry.size.width > 500 ? 32 : 20)
                            .border(Color.black, width: 2)
                            .padding(.bottom, 16)
                            
                            VStack {
                                Text("Overall, how intense are these feelings? \n(from 1: very light to 7: very intense)")
                                    .font(.custom("Poppins-Regular", size: geometry.size.width > 500 ? 16 : 12))
                                    .multilineTextAlignment(.center)
                                
                                Slider(value: $emotionStrength, in: 1...7, step: 1) {
                                    Text("Value")
                                } minimumValueLabel: {
                                    Text("1")
                                } maximumValueLabel: {
                                    Text("7")
                                }
                                .padding(.horizontal)
                                
                                Text("\(Int(emotionStrength))")
                            }
                            .frame(width: .infinity)
                            .padding(geometry.size.width > 500 ? 32 : 20)
                            .border(Color.black, width: 2)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            Text("If you do not mind, can you share more about your feelings?")
                                .font(.custom("Poppins-Regular", size: geometry.size.width > 500 ? 20 : 16))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            TextEditor(text: $emotionDetails)
                                .padding()
                                .frame(height: 150)
                                .border(Color.black, width: 2)
                                .cornerRadius(4)
                        }
                        .padding()
                        .padding(.top, 16)
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, 8)
                        }
                        
                        Button(action: {
                            guard validateData() else { return }
                            let userId = Auth.auth().currentUser?.email
                            sessionId = UUID().uuidString
                            dataManager.submitSession(sessionId: sessionId, emotionStrength: emotionStrength, emotionValue: emotionValue, description: emotionDetails, userId: userId ?? "")
                            redirect = true
                        }) {
                            Text("Done")
                                .font(.custom("Poppins-Regular", size: 24))
                                .fontWeight(.semibold)
                                .padding(20)
                                .padding(.horizontal, 88)
                                .background(.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(30)
                        .fullScreenCover(isPresented: $redirect, content: {
                            RedirectPopUp(showingPopup: $redirect, sessionId: $sessionId, emotionValue: $emotionValue, emotionStrength: $emotionStrength)
                        })
                    }
                }
                .padding(geometry.size.width > 500 ? 50 : 5)
            }
            .scaleEffect(geometry.size.width > 500 ? 1.0 : 0.9)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func validateData() -> Bool {
        if (emotionStrength == 0 || emotionValue == 0 || emotionDetails == "") {
            errorMessage = "Please answer all the question"
            return false
        }
        errorMessage = nil
        return true
    }
}
    
    
    #Preview {
        EmotionInput(inputEmotion: .constant(true))
            .environmentObject(DataManager())
    }

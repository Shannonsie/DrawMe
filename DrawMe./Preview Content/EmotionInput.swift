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
    @State var selectedEmotion = ""
    @State var emotionDetails: String = ""
    @State private var redirect = false
    @Binding var inputEmotion: Bool
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack{
            HStack{
                Button("< Back") {
                    inputEmotion = false;
                }
                .font(.custom("Poppins-Regular", size: 24))
                Spacer()
            }.navigationTitle("Emotion Input")
            
            ScrollView{
                VStack{
                    VStack{
                        Text("Hi, How is your feeling today?")
                            .font(.custom("Poppins-Regular", size: 32))
                            .fontWeight(.semibold)
                            .padding(4)
                        Text("We'd love to hear your thoughts, click the button that best reflects how you're feeling right now.")
                            .font(.custom("Poppins-Regular", size: 20))
                            .multilineTextAlignment(.center)
                    }.padding(60)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20){
                        ForEach(dataManager.emotions, id: \.id){
                            emotion in Button {
                                selectedEmotion = emotion.name
                            } label: {
                                VStack{
                                    Text(emotion.name)
                                        .font(.custom("Poppins-Regular", size: 20))
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                .frame(width: 165, height: 190)
                                .clipped()
                                .background(selectedEmotion == emotion.name ? Color.yellow : Color.black)
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    VStack{
                        Text("Can you tell us more about it?")
                            .font(.custom("Poppins-Regular", size: 24))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Describe your emotion",
                                  text: $emotionDetails
                        )
                        .padding()
                        .frame(height: 150)
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                        .cornerRadius(4)
                    }
                    .padding()
                    .padding(.top, 32)
                    
                    Button(action: {
                        let userId = Auth.auth().currentUser?.email
                        sessionId = UUID().uuidString
                        dataManager.submitSession(sessionId: sessionId, emotion: selectedEmotion, description: emotionDetails, userId: userId ?? "")
                        redirect = true
                    }){
                        Text("Done")
                            .font(.custom("Poppins-Regular", size: 24))
                            .fontWeight(.semibold)
                            .padding(20)
                            .padding(.horizontal, 88)
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }.padding(60)
                        .fullScreenCover(isPresented: $redirect, content: {
                            RedirectPopUp(showingPopup: $redirect, sessionId: $sessionId)
                    })
                }
                }
            }.padding(50)
        }
    }
    
    
    #Preview {
        EmotionInput(inputEmotion: .constant(true))
            .environmentObject(DataManager())
    }

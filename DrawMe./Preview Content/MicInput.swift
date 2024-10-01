//
//  ContentView.swift
//  DrawMe.
//
//  Created by Shannon Sie Santosa on 17/8/2024.
//

import SwiftUI
import SwiftData
import AVFoundation

struct HomePage: View {
    @StateObject var dataManager = DataManager()
    @State var selectedEmotion = ""
    @State var emotionDetails: String = ""
    @State var isRecording = false
    @State var audioURL: URL?
    @State var audioRecorder: AVAudioRecorder?
    @State var recognizedText = ""
    
//   for going to next page
    @State private var inputEmotion = false
 
    
    var body: some View {
        ScrollView{
            VStack{
                VStack{
                    Text("Hi, How is your feeling today?")
                        .font(.custom("Poppins-Regular", size: 32))
                        .fontWeight(.semibold)
                        .padding(4)
                    Text("We're excited to hear your thoughts and capture your creative ideas! Click the button when you're ready to begin the session!")
                        .font(.custom("Poppins-Regular", size: 20))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                .padding(.horizontal, 50)
                
                Image("thinking-icon")
                    .resizable()
                    .frame(width: 615, height: 550)
                    .padding(.top, 30)
                
                Button(action: {
                  inputEmotion = true
                }){
                    Text("Next")
                        .font(.custom("Poppins-Regular", size: 24))
                        .fontWeight(.semibold)
                        .padding(20)
                        .padding(.horizontal, 88)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }.padding(.top, 90)
                    .fullScreenCover(isPresented: $inputEmotion, content: {
                        EmotionInput(inputEmotion: $inputEmotion)
                            .environmentObject(dataManager)
                    })
            }
        }.padding(50)
    }
    
}



#Preview {
    HomePage()
        .modelContainer(for: Item.self, inMemory: true)
}



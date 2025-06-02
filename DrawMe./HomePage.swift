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
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    // Header Texts
                    VStack(spacing: 16) { // Add spacing for better readability
                        Text("Hi, How is your feeling today?")
                            .font(.custom("Poppins-Regular", size: geometry.size.width > 500 ? 32 : 24)) // Adjust font size for smaller screens
                            .fontWeight(.semibold)
                            .padding(geometry.size.width > 500 ? 4 : 2)
                        
                        Text("""
                        We're excited to hear your thoughts and capture your creative ideas! Click the button when you're ready to begin the session!
                        """)
                            .font(.custom("Poppins-Regular", size: geometry.size.width > 500 ? 20 : 14)) // Adjust font size
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, geometry.size.width > 500 ? 50 : 5) // Reduce padding for smaller screens
                    }
                    .padding(.top, geometry.size.width > 500 ? 60 : 60) // Adjust top padding based on screen size
                    
                    // Image Section
                    Image("thinking-icon")
                        .resizable()
                        .scaledToFit() // Automatically scale the image proportionally
                        .frame(width: geometry.size.width > 500 ? 550 : geometry.size.width * 1, // Dynamically adjust width
                               height: geometry.size.width > 500 ? 550 : geometry.size.width * 1) // Dynamically adjust height
                        .padding(.top, geometry.size.width > 500 ? 30 : 1) // Adjust top padding
                    
                    // Next Button
                    Button(action: {
                        inputEmotion = true
                    }) {
                        Text("Next")
                            .font(.custom("Poppins-Regular", size: geometry.size.width > 500 ? 24 : 20)) // Adjust font size
                            .fontWeight(.semibold)
                            .padding(20)
                            .padding(.horizontal, geometry.size.width > 500 ? 88 : 55) // Adjust button width for smaller screens
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, geometry.size.width > 500 ? 90 : 50) // Adjust top padding

                    // Navigate to EmotionInput
                    .fullScreenCover(isPresented: $inputEmotion) {
                        EmotionInput(inputEmotion: $inputEmotion)
                            .environmentObject(dataManager)
                    }
                }
                .padding(geometry.size.width > 500 ? 50 : 10) // Reduce overall padding for smaller screens
                .scaleEffect(geometry.size.width > 500 ? 1.0 : 0.85) // Shrink layout for smaller screens
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    
}



#Preview {
    HomePage()
        .modelContainer(for: Item.self, inMemory: true)
}



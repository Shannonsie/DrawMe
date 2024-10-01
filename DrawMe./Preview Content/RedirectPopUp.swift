//
//  RedirectPopUp.swift
//  DrawMe.
//
//  Created by Shannon Sie Santosa on 17/8/2024.
//

import SwiftUI
import UserNotifications

struct RedirectPopUp: View {
    @Binding var showingPopup: Bool
    @Binding var sessionId: String
    @StateObject var dataManager = DataManager()
    @State private var navigateToUploadView = false
    
    var body: some View {
        VStack {
            VStack{
                Text("Are you ready to start drawing now?")
                    .font(.custom("Poppins-Regular", size: 32))
                    .fontWeight(.semibold)
                    .padding(4)
                Text("Time to unleash your creativity! We're taking you to our amazing **paint app**, where you can let your imagination run wild.")
                    .font(.custom("Poppins-Regular", size: 20))
                    .multilineTextAlignment(.center)
            }.padding(.top, 36)
            
            Image("writing-icon")
                .resizable()
                .frame(width: 320, height: 280)
            
            HStack{
                Button(action: {
                    showingPopup = false;
                    print("showingPopUp false")
                }){
                    Text("Cancel")
                        .foregroundStyle(.black)
                        .font(.custom("Poppins-Regular", size: 24))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .frame(width: 300, height: 75)
                .background(.white)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .padding(8)
                Button(action: {
                navigateToUploadView = true
//                    requestNotificationPermission()
//                    openNotesApp()
                }){
                    Text("Yes, start now!")
                        .foregroundColor(.white)
                        .font(.custom("Poppins-Regular", size: 24))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .frame(width: 300, height: 75)
                .background(.black)
                .padding(8)
                .cornerRadius(8)
            }  .padding(.top, 48)
        }.padding(40)
        .frame(height: 700)
        .cornerRadius(16)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        .padding(25)
        .fullScreenCover(isPresented: $navigateToUploadView) {
            UploadView(sessionId: $sessionId, uploadPopUp: $navigateToUploadView) // Present UploadView
            }
    }
    
}

#Preview {
    RedirectPopUp(showingPopup: .constant(false), sessionId: .constant(""))
}

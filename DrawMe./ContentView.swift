//
//  ContentView.swift
//  FirebaseTemplate
//
//  Created by Shannon Sie Santosa on 8/9/2024.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    
    var body: some View {
        if userIsLoggedIn{
            HomePage()
        } else   {
            content
        }
    }
    
    var content: some View {
        ZStack{
            Color.black
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors:[.black, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            VStack(spacing: 20){
                Text("Welcome to DrawMe!")
                    .foregroundColor(.white)
                    .font(.custom("Poppins", fixedSize: 40).bold())
                    .offset(x: -100, y: -100)
                
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty){
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty){
                        Text("Password")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                
                
                Button{
                    register()
                } label : {
                    Text("Register")
                        .foregroundColor(.white)
                        .font(.custom("Poppins", size: 20))
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill()
                        )
                }
                .padding(.top)
                .offset(y: 100)
                
                Button{
                    login()
                } label : {
                    Text("Already have an account? Login")
                        .foregroundColor(.black)
                        .bold()
                }
                .padding(.top)
                .offset(y: 110)

            }.frame(width: 350)
            .onAppear{
                    Auth.auth().addStateDidChangeListener{auth, user in
                        if user != nil {
                            userIsLoggedIn.toggle()
                        }
                    }
                }
        }
        .ignoresSafeArea()
    }
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password){
            result, error in if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email, password: password){
            result, error in if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment){
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

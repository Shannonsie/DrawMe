
import SwiftUI
import SwiftData
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var screenSize = ""
    @State private var userIsLoggedIn = false
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        if userIsLoggedIn{
            HomePage()
        } else   {
            content
        }
    }
    
    var content: some View {
        GeometryReader { geometry in
            ZStack{
                Color.black
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundStyle(.linearGradient(colors:[.black, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                
                VStack(spacing: 20){
                    Text("Welcome to EmoFlow!")
                        .foregroundColor(.white)
                        .font(.custom("Poppins", fixedSize: 40).bold())
                        .offset(x: geometry.size.width > 500 ? -100 : -50, y:  geometry.size.width > 500 ? -100 : -50)
                    
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
                    
                    TextField("Screen Size", text: $screenSize)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .placeholder(when: screenSize.isEmpty){
                            Text("Screen Size")
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
                    
//                Button{
//                    login()
//                } label : {
//                    Text("Already have an account? Login")
//                        .foregroundColor(.black)
//                        .bold()
//                }
//                .padding(.top)
//                .offset(y: 110)
                    
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
    }
    
    func register() {
        guard !email.isEmpty, !password.isEmpty, !screenSize.isEmpty else {
            print("Error: Email, password, or screen size is empty")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                return
            }
            
//            dataManager.submitUser(user: email, screenSize: screenSize)
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
        .environmentObject(DataManager())
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

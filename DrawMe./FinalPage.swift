import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct FinalPage: View {
    @State private var drawingDescription: String = ""
    @State private var errorMessage: String? = nil
    @State private var thankYouPage = false
    @Binding var sessionId: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                
                VStack{
                    Text("How did this drawing help express your feelings and emotions?")
                        .font(.custom("Poppins-Regular", size: geometry.size.width > 500 ? 24 : 20))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    TextEditor(text: $drawingDescription)
                        .padding()
                        .frame(height: 200)
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                        .cornerRadius(4)
                        .padding(16)
                }
                .padding(geometry.size.width > 500 ? 60 : 20)
                .padding(.top, 32)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 8)
                }
                
                Spacer()
                
                Button(action: {
                    guard validateData() else {return}
                    let db = Firestore.firestore()
                    db.collection("sessions").whereField("sessionId", isEqualTo: sessionId).getDocuments(){ querySnapshot, error in
                        if let error = error {
                            print("Error fetching documents: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                            print("No matching documents found.")
                            return
                        }
                        
                        let document = documents.first
                        document?.reference.updateData([
                            "drawingDescription": drawingDescription
                        ])
                    }
                    
                    thankYouPage = true
                    
                    
                }){
                    Text("Save")
                        .font(.custom("Poppins-Regular", size: geometry.size.width > 500 ? 24 : 20))
                        .fontWeight(.semibold)
                        .padding(20)
                        .padding(.horizontal, geometry.size.width > 500 ? 88 : 44)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(geometry.size.width > 500 ? 60 : 30)
                .fullScreenCover(isPresented: $thankYouPage) {
                    EmoFlow.thankYouPage()
                }}
                
                Spacer()
        }
       
    }
    
    private func validateData() -> Bool {
        if drawingDescription.isEmpty{
            errorMessage = "Please describe what you draw"
            return false
        }
        errorMessage = nil
        return true
    }
}

#Preview {
    
    FinalPage(sessionId: .constant(""))
        .previewInterfaceOrientation(.landscapeLeft)

}

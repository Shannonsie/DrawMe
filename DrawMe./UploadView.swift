//import SwiftUI
//import UserNotifications
//import FirebaseStorage
//import FirebaseFirestore
//
//struct UploadView: View {
//    @Binding var sessionId: String
//    @Binding var uploadPopUp: Bool
//    @Binding var selectedEmotion: String
//    
//    @State private var isPresented = false
//    @State private var selectedImage: UIImage?
//    @State private var pickerShown = false
//    @State private var isFinished = false
//    
////    init() {
////        requestNotificationPermission()
////        openNotesApp()
////    }
//
//    var body: some View {
//        VStack {
//
//            Text("Upload your drawings!")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding(4)
//            Button(action: {
//                pickerShown = true
//                }) {
//                Text("Select a photo")
//            }
//                .sheet(isPresented: $pickerShown, onDismiss: nil){
//                    ImagePicker(selectedImage: $selectedImage, isPickerShowing: $pickerShown)
//                }
//            
//            if selectedImage != nil {
//                Image(uiImage: selectedImage!)
//                    .resizable()
//                    .frame(width: 600, height: 900)
//            }
//               
//            Spacer()
//            HStack {
//                Button(action: {
//                    uploadPopUp = false
//                }) {
//                    Text("Cancel")
//                        .foregroundStyle(.black)
//                        .font(.title2)
//                        .fontWeight(.bold)
//                }
//                .frame(width: 300, height: 75)
//                .background(.white)
//                .border(Color.black)
//                .padding()
//                
//                Button(action: {
//                    uploadPhoto()
//                }) {
//                    Text("Submit")
//                        .foregroundColor(.white)
//                        .font(.title2)
//                        .fontWeight(.bold)
//                }
//                .frame(width: 300, height: 75)
//                .background(.black)
//                .cornerRadius(8)
//            }
//            .padding(32)
//        }
//        .padding(40)
//        .onAppear {
//            requestNotificationPermission()
//            openNotesApp()
//            
//            // Set up the observer when the view appears
//            NotificationCenter.default.addObserver(forName: Notification.Name("NavigateToUploadView"), object: nil, queue: .main) { _ in
//                isPresented = true
//            }
//        }
//        .fullScreenCover(isPresented: $isFinished) {
//            HomePage()
//        }
//      
//    }
//    func uploadPhoto(){
//        let storageRef = Storage.storage().reference()
//        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
//        guard imageData != nil else {
//            return
//        }
//        
//        let path = "images/\(UUID().uuidString)_\(selectedEmotion).jpg"
//        let fileRef = storageRef.child(path)
//        _ = fileRef.putData(imageData!, metadata: nil){
//            metadata, error in
//            if error == nil && metadata != nil{
//                let db = Firestore.firestore()
//                db.collection("sessions").whereField("sessionId", isEqualTo: sessionId).getDocuments { snapshot, error in
//                    if let error = error {
//                        print("Error fetching documents: \(error)")
//                        return
//                    }
//                    
//                    // Check if a matching document exists
//                    if let document = snapshot?.documents.first {
//                        // Update the existing document with the new imageUrl
//                        document.reference.updateData([
//                            "imageUrl": path
//                        ]) { error in
//                            if let error = error {
//                                print("Error updating session with image URL: \(error)")
//                            } else {
//                                print("Image URL saved to session successfully.")
//                                isFinished = true
//                            }
//                        }
//                    } else {
//                        print("No matching session found for sessionId: \(sessionId)")
//                    }
//                }
//            }
//        }}
//
//    func dispatchNotification() {
//        let identifier = "upload-notification"
//        let title = "Upload your masterpiece!"
//        let body = "It has been 15 minutes, are you finished yet?"
//
//        let notificationCenter = UNUserNotificationCenter.current()
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1 * 10, repeats: false)
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
//        notificationCenter.add(request)
//    }
//
//    func openNotesApp() {
//        if let url = URL(string: "mobilenotes://") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:]) { success in
//                    if success {
//                        dispatchNotification()
//                    }
//                }
//            }
//        }
//    }
//
//    func requestNotificationPermission() {
//        let center = UNUserNotificationCenter.current()
//        center.getNotificationSettings { settings in
//            switch settings.authorizationStatus {
//            case .notDetermined:
//                center.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
//                    if didAllow {
//                        dispatchNotification() // Schedule notification after permission granted
//                    }
//                }
//            case .denied:
//                return
//            case .authorized:
//                dispatchNotification() // Schedule notification if already authorized
//            default:
//                return
//            }
//        }
//    }
//}
//
//#Preview {
//    UploadView(sessionId: .constant(""), uploadPopUp: .constant(false), selectedEmotion: .constant("Angry"))
//}

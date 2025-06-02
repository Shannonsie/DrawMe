//
//  DataManager.swift
//  DrawMe.
//
//  Created by Shannon Sie Santosa on 22/9/2024.
//

import SwiftUI
import Firebase

class DataManager: ObservableObject{
    @Published var emotions: [Emotion] = []
    
    init(){
//        fetchEmotions()
    }
    
//    func fetchEmotions(){
//        emotions.removeAll()
//        let db = Firestore.firestore()
//        let ref = db.collection("emotions")
//        ref.getDocuments { snapshot, error in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//            
//            if let snapshot = snapshot {
//                for document in snapshot.documents{
//                    let data = document.data()
//                    
//                    let id = data["id"] as? String ?? ""
//                    let name = data["name"] as? String ?? ""
//                    
//                    let emotion = Emotion(id: id, name: name)
//                    self.emotions.append(emotion)
//                    
//                }
//                print("Fetched emotions: ", self.emotions)
//            }
//        }
//        
//    }
    
    func submitSession(sessionId: String, emotionStrength: CGFloat, emotionValue: CGFloat, description: String, userId: String){
        print(emotionValue, emotionStrength, "submitted")
        let db = Firestore.firestore()
        
        db.collection("sessions").addDocument(data: ["sessionId": sessionId, "emotionValue": emotionValue, "emotionStrength": emotionStrength, "description": description, "timestamp": FieldValue.serverTimestamp(), "userId": userId])
        {
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func submitUser(user: String, screenSize: String){
        let db = Firestore.firestore()
        db.collection("user").addDocument(data: ["user": user, "screen size": screenSize])
        {
            error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
}

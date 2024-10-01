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
        fetchEmotions()
    }
    
    func fetchEmotions(){
        emotions.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("emotions")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents{
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    
                    let emotion = Emotion(id: id, name: name)
                    self.emotions.append(emotion)
                    
                }
            }
        }
        
    }
    
    func submitSession(sessionId: String, emotion: String, description: String, userId: String){
        let db = Firestore.firestore()
        
        db.collection("sessions").addDocument(data: ["sessionId": sessionId, "emotion": emotion, "description": description, "timestamp": FieldValue.serverTimestamp(), "userId": userId])
        {
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

//
//  DrawMe_App.swift
//  DrawMe.
//
//  Created by Shannon Sie Santosa on 17/8/2024.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseDatabase

@main
struct DrawMe_App: App {    
    init(){
        FirebaseApp.configure()
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
           ContentView()
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}


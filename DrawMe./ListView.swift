//
//  ListView.swift
//  DrawMe.
//
//  Created by Shannon Sie Santosa on 22/9/2024.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView{
            List(dataManager.emotions, id: \.id){
                emotion in
                Text(emotion.name)
            }
            .navigationTitle("Emotions")
            .navigationBarItems(trailing: Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "plus")
            }))
        }
    }
}

#Preview {
    ListView()
        .environmentObject(DataManager())
}

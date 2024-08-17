//
//  Item.swift
//  DrawMe.
//
//  Created by Shannon Sie Santosa on 17/8/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

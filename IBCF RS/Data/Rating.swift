//
//  Rating.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 14/02/23.
//

import Foundation

struct Rating {
    let userId: Int
    let itemId: Int
    let value: Double
    let createdAt: Date?
    
    init(userId: Int, itemId: Int, value: Double, createdAt: Date?) {
        self.userId = userId
        self.itemId = itemId
        self.value = value
        self.createdAt = createdAt != nil ? createdAt : Date.now
    }
}

//
//  FBRating.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 22/03/23.
//

import Foundation

struct FBRating: Codable, Equatable {
    var userId: String?
    var itemId: String?
    var value: Double?
    var createdAt: Date?
}

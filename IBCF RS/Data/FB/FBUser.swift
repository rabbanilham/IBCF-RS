//
//  FBUser.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 22/03/23.
//

import FirebaseFirestoreSwift
import Foundation

struct FBUser: Codable {
    @DocumentID var id: String?
    var name: String?
    var email: String?
    var phoneNumber: String?
    var ratings: [FBRating]?
}

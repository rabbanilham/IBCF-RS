//
//  FBUtilities.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 22/03/23.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class FBUtilities {
    static let shared = FBUtilities()
    let database = Firestore.firestore()
    
    func getUsers(
        _ completion: @escaping ([FBUser]?, Error?) -> Void
    ) {
        let usersReference = database.collection("user")
        var users = [FBUser]()
        
        usersReference.getDocuments { document, error in
            if let document = document {
                for user in document.documents {
                    do {
                        let theUser = try user.data(as: FBUser.self)
                        users.append(theUser)
                    } catch {
                        print(String(describing: error))
                        completion(nil, error)
                    }
                }
                completion(users, nil)
            }
        }
    }
    
    func getRatings(
        _ completion: @escaping ([FBRating]?, Error?) -> Void
    ) {
        getUsers { [weak self] users, error in
            guard let _ = self, let users = users else {
                completion(nil, error)
                return
            }
            
            var ratings = [FBRating]()
            for user in users {
                if let userRatings = user.ratings {
                    for userRating in userRatings {
                        ratings.append(userRating)
                    }
                }
            }
            completion(ratings, nil)
        }
    }
    
    func createUser(
        user: FBUser,
        _ completion: @escaping (Error?) -> Void
    ) {
        do {
            try database.collection("user").document(user.id ?? "0").setData(from: user.self, merge: false, completion: { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            })
        } catch {
            print(String(describing: error))
        }
    }
    
    func isUserExist(
        id: String,
        _ completion: @escaping (Bool, FBUser?, Error?) -> Void
    ) {
        let userReference = database.collection("user").document(id)
        
        userReference.getDocument { [weak self] response, error in
            guard let _ = self, let response = response else {
                completion(false, nil, error)
                return
            }
            do {
                let user = try response.data(as: FBUser.self)
                completion(response.exists, user, nil)
            } catch {
                print(String(describing: error))
                completion(response.exists, nil, nil)
            }
        }
    }
}


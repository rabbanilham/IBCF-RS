//
//  DefaultsUtilities.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 26/03/23.
//

import Foundation

final class DefaultUtilities {
    enum Path: String {
        case userId = "userId"
        case userName = "userName"
        case userEmail = "userEmail"
        case userPhoneNumber = "userPhoneNumber"
        case submissionType = "submissionType"
        case isPredictionValueShown = "isPredictionValueShown"
    }
    
    enum SubmissionType: String {
        case getPrediction = "getPrediction"
        case contribute = "contribute"
    }
    
    static let shared = DefaultUtilities()
    
    func setCurrentUser(
        id: String,
        name: String,
        email: String,
        phoneNumber: String
    ) {
        UserDefaults.standard.set(id, forKey: Path.userId.rawValue)
        UserDefaults.standard.set(name, forKey: Path.userName.rawValue)
        UserDefaults.standard.set(email, forKey: Path.userEmail.rawValue)
        UserDefaults.standard.set(phoneNumber, forKey: Path.userPhoneNumber.rawValue)
    }
    
    func getCurrentUser() -> FBUser? {
        if let id = UserDefaults.standard.value(forKey: Path.userId.rawValue) as? String,
           let name = UserDefaults.standard.value(forKey: Path.userName.rawValue) as? String,
           let email = UserDefaults.standard.value(forKey: Path.userEmail.rawValue) as? String,
           let phoneNumber = UserDefaults.standard.value(forKey: Path.userPhoneNumber.rawValue) as? String
        {
            let user = FBUser(id: id, name: name, email: email, phoneNumber: phoneNumber)
            
            return user
        }
        
        return nil
    }
    
    func setCurrentSubmissionType(_ submissionType: SubmissionType) {
        UserDefaults.standard.set(submissionType.rawValue, forKey: Path.submissionType.rawValue)
    }
    
    func getCurrentSubmissionType() -> DefaultUtilities.SubmissionType.RawValue? {
        let type = UserDefaults.standard.value(forKey: Path.submissionType.rawValue) as? SubmissionType.RawValue
        
        return type
    }
    
    func setIsPredictionValueShown(_ isShown: Bool) {
        UserDefaults.standard.set(isShown, forKey: Path.isPredictionValueShown.rawValue)
    }
    
    func getIsPredictionValueShown() -> Bool {
        if let value = UserDefaults.standard.value(forKey: Path.isPredictionValueShown.rawValue) as? Bool {
            return value
        }
        
        return false
    }
}

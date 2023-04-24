//
//  String+Extension.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 22/03/23.
//

import Foundation

extension String {
    var isValidNPM: Bool {
        let regularExpressionForNPM = "140110+[0-9]{6,6}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForNPM)
        return testEmail.evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let regularExpressionForEmail = "08+[0-9]{7,10}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
}

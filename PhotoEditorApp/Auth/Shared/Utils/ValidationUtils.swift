//
//  ValidationUtils.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 07.08.2024.
//

import Foundation

enum ValidationUtils {
    private static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    static func validateEmail(_ email: String) -> EmailValidationState {
        if (email.isEmpty) {
            return EmailValidationState.empty
        }
        
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let isValid =  emailPred.evaluate(with: email)
        
        if (!isValid) {
            return EmailValidationState.invalidFormat
        }
        
        return EmailValidationState.valid
    }
    
    static func validatePassword(_ password: String) -> PasswordValidationState {
        if (password.isEmpty) {
            return PasswordValidationState.empty
        }
        
        return PasswordValidationState.valid
    }
    
    enum EmailValidationState {
        case valid
        case invalidFormat
        case empty
    }
    
    enum PasswordValidationState {
        case valid
        case empty
    }
}

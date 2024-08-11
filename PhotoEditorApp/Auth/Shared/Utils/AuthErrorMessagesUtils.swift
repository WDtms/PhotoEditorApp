//
//  ErrorMessagesUtils.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 08.08.2024.
//

import Foundation

enum AuthErrorMessagesUtils {
    static func emailValidationErrorMessage(emailValidation: ValidationUtils.EmailValidationState) -> String? {
        return switch emailValidation {
        case .invalidFormat :
            "Invalid email format."
        case .empty :
            "The field must be filled in."
        case .valid:
            nil
        }
    }
    
    static func passwordValidationErrorMessage(passwordValidation: ValidationUtils.PasswordValidationState) -> String? {
        return switch passwordValidation {
        case .empty:
            "The field must be filled in."
        case .valid:
            nil
        }
    }
}

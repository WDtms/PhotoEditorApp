//
//  ResetPasswordViewModel.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 07.08.2024.
//

import Foundation

class ResetPasswordViewModel: ObservableObject {
    
    var authService: AuthService?
    
    @Published var state: ResetPasswordState = .idle
    
    @Published var email: String = "" {
        didSet {
            if case .validating(_) = state {
                _ = validateEmail()
            }
        }
    }
    
    func resetPassword() {
        let isValid = validateEmail()
        
        if (!isValid) {
            return
        }
        
        return sendResetPasswordEmail()
    }
    
    private func validateEmail() -> Bool {
        let emailValidation = ValidationUtils.validateEmail(email)
        
        if (emailValidation == .valid) {
            state = .idle
            
            return true
        }
        
        state = .validating(email: emailValidation)
        
        return false
    }
    
    private func sendResetPasswordEmail() {
        state = .loading
        
        guard let authService = authService else { return }
        
        let emailToSend = email
        
        authService.sendResetPasswordLink(email: emailToSend) { [weak self] actionResult in
            guard let self = self else { return }
            
            switch actionResult {
            case .error(let error):
                self.state = .error(localizedErrorText: error?.localizedDescription)
            case .success(_):
                self.state = .success(email: emailToSend)
            }
        }
    }
}

enum ResetPasswordState : Equatable {
    case idle
    case validating(email: ValidationUtils.EmailValidationState)
    case loading
    case error(localizedErrorText: String?)
    case success(email: String)
}

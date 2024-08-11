//
//  SignInViewModel.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 07.08.2024.
//

import Foundation

class SignInViewModel : ObservableObject {
    
    var authService: AuthService?
    
    @Published var state: SignInState = .idle
    
    @Published var email: String = "" {
        didSet {
            if case .validating(_, let password) = state {
                let validatedEmail = ValidationUtils.validateEmail(email)
                
                _ = handleValidation(email: validatedEmail, password: password)
            }
        }
    }
    
    @Published var password: String = "" {
        didSet {
            if case .validating(let email, _) = state {
                let validatedPassword = ValidationUtils.validatePassword(password)
                
                _ = handleValidation(email: email, password: validatedPassword)
            }
        }
    }
    
    func signInWithGoogle() {
        state = .loading
        
        guard let authService = authService else { return }

        authService.signInWithGoogle { [weak self] actionResult in
            guard let self = self else { return }
            
            switch actionResult {
            case .success(_):
                self.state = .success
            case .error(let error):
                self.state = .error(localizedError: error?.localizedDescription)
            }
        }
    }
    
    func signInWithEmailAndPassword() {
        let validatedEmail = ValidationUtils.validateEmail(email)
        let validatedPassword = ValidationUtils.validatePassword(password)
        
        let isValid = handleValidation(email: validatedEmail, password: validatedPassword)
        
        if (isValid) {
            return authenticate()
        }
    }
    
    private func handleValidation(email: ValidationUtils.EmailValidationState, password: ValidationUtils.PasswordValidationState) -> Bool {
        if (email == .valid && password == .valid) {
            state = .idle
            
            return true
        }
        
        state = .validating(email: email, password: password)
        
        return false
    }
    
    private func authenticate() {
        state = .loading
        
        guard let authService = authService else { return }
        
        authService.signInWithCredentials(email: email, password: password) { [weak self] actionResult in
            guard let self = self else { return }
            
            switch actionResult {
            case .error(let error):
                self.state = .error(localizedError: error?.localizedDescription)
            case .success(_):
                self.state = .success
            }
        }
    }
}

enum SignInState : Equatable {
    case idle
    case validating(email: ValidationUtils.EmailValidationState, password: ValidationUtils.PasswordValidationState)
    case loading
    case error(localizedError: String?)
    case success
}

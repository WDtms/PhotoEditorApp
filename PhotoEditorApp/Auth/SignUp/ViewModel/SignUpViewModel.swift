//
//  SignUpViewModel.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 07.08.2024.
//

import Foundation

class SignUpViewModel: ObservableObject {
    
    var authService: AuthService?
    
    @Published var state: SignUpState = .idle
    
    @Published var email: String = "" {
        didSet {
            if case .validating(_, let password, _) = state {
                let validatedEmail = ValidationUtils.validateEmail(email)
                
                _ = handleValidation(emailValidation: validatedEmail, passwordValidation: password)
            }
        }
    }
    
    @Published var password: String = "" {
        didSet {
            if case .validating(let email, _, _) = state {
                let validatedPassword = ValidationUtils.validatePassword(password)
                
                _ = handleValidation(emailValidation: email, passwordValidation: validatedPassword)
            }
        }
    }
    
    @Published var repeatedPassword: String = "" {
        didSet {
            if case .validating(let email, let password, _) = state {
                _ = handleValidation(emailValidation: email, passwordValidation: password)
            }
        }
    }
    
    func signUpWithGoogle() {
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
    
    func signUpWithEmailAndPassword() {
        let validatedEmail = ValidationUtils.validateEmail(email)
        let validatedPassword = ValidationUtils.validatePassword(password)
        
        let isValid =  handleValidation(emailValidation: validatedEmail, passwordValidation: validatedPassword)
        
        if (isValid) {
            return authenticate()
        }
    }
    
    private func handleValidation(emailValidation: ValidationUtils.EmailValidationState, passwordValidation: ValidationUtils.PasswordValidationState) -> Bool {
        let repeatedPasswordValidation = self.password == repeatedPassword ? RepeatedPasswordValidationState.valid : RepeatedPasswordValidationState.notMatch
        
        
        if (emailValidation == .valid && passwordValidation == .valid && repeatedPasswordValidation == .valid) {
            state = .idle
            
            return true
        }
        
        state = .validating(email: emailValidation, password: passwordValidation, repeatedPassword: repeatedPasswordValidation)
        
        return false
    }
    
    private func authenticate() {
        state = .loading
        
        guard let authService = authService else { return }
        
        authService.signUpWithCredentials(email: email, password: password) { [weak self] actionResult in
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

enum SignUpState : Equatable {
    case idle
    case validating(email: ValidationUtils.EmailValidationState, password: ValidationUtils.PasswordValidationState, repeatedPassword: RepeatedPasswordValidationState)
    case loading
    case error(localizedError: String?)
    case success
}

enum RepeatedPasswordValidationState {
    case valid
    case notMatch
}

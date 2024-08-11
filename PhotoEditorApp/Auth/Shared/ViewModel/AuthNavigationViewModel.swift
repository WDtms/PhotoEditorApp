//
//  AuthNavigationViewModel.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 08.08.2024.
//

import Foundation
import FirebaseAuth

enum AuthNavigationState {
    case signUp
}

class AuthNavigationViewModel : ObservableObject {
    
    @Published var path: [AuthNavigationState] = []
    
    @Published var isResetingPassword: Bool = false
    
    func goToSignUp() {
        path.append(.signUp)
    }
    
    func showResetModal() {
        isResetingPassword = true
    }
    
    func hideResetModal() {
        isResetingPassword = false
    }
    
    func goBack() {
        if path.count > 0 {
            path.removeLast()
        }
    }
}

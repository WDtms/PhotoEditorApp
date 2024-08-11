//
//  ProfileViewModel.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import Foundation

enum ProfileState {
    case idle
    case error
}

class ProfileViewModel: ObservableObject {
    var authService: AuthService?
    
    @Published var state: ProfileState = .idle
    
    func logOut() {
        guard let authService = authService else { return }
        
        authService.logOut { [weak self] actionResult in
            guard let self = self else { return }
            
            switch actionResult {
            case .error(_):
                self.state = .error
            case .success(_):
                self.state = .idle
            }
        }
    }
}

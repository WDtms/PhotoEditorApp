//
//  AuthRootView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 08.08.2024.
//

import SwiftUI

struct AuthRootView: View {
    
    @StateObject private var authNavigationViewModel: AuthNavigationViewModel = AuthNavigationViewModel()
    
    var body: some View {
        
        NavigationStack(path: $authNavigationViewModel.path) {
             SignInScreenView()
                .environmentObject(authNavigationViewModel)
                .navigationDestination(for: AuthNavigationState.self) { state in
                    if state == .signUp {
                        SignUpScreenView()
                            .environmentObject(authNavigationViewModel)
                    }
            }
            
        }
        .sheet(isPresented: $authNavigationViewModel.isResetingPassword) {
            ResetPasswordScreenView()
                .environmentObject(authNavigationViewModel)
        }
        
    }
}

#Preview {
    AuthRootView()
}

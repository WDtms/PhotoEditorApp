//
//  RootView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import SwiftUI

struct RootScreenView: View {
    @StateObject var authService: AuthService = AuthService()
    
    var body: some View {
        switch authService.state {
        case .initial:
            SplashScreenView()
        case .loggedOut:
            AuthRootView()
                .environmentObject(authService)
        case .loggedIn(let userInfo):
            PhotoEditorRootView()
                .environmentObject(authService)
                .environment(\.userInfo, userInfo)
        }
    }
}

#Preview {
    RootScreenView()
}

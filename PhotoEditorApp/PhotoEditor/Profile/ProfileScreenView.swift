//
//  ProfileScreenView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import SwiftUI

struct ProfileScreenView: View {
    
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    @EnvironmentObject private var authService: AuthService
    
    @Environment(\.userInfo) private var userInfo: UserInfo
    
    var body: some View {
        VStack {
            
            UserAvatarView(diameter: 200)
            
            Spacer()
                .frame(height: 20)
            
            Text(userInfo.userEmail ?? "Anonymous")
                .font(.title)
            
            Spacer()
            
            Button("Log Out", role: .destructive) {
                profileViewModel.logOut()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .navigationTitle("Profile")
        .onAppear {
            profileViewModel.authService = authService
        }
        .alert("Oops!", isPresented: Binding(get: {
            if case .error = profileViewModel.state {
                return true
            }
            
            return false
        }, set: { _ in
            profileViewModel.state = .idle
        })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Something went wrong. Try again later.")
        }

    }
}

#Preview {
    ProfileScreenView()
}

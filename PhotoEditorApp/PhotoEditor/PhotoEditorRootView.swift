//
//  PhotoEditorRootView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 08.08.2024.
//

import SwiftUI
import PhotosUI

struct PhotoEditorRootView: View {
    @StateObject var photoEditorNavigationViewModel: PhotoEditorNavigationViewModel = PhotoEditorNavigationViewModel()
    
    var body: some View {
        
        NavigationStack(path: $photoEditorNavigationViewModel.path) {
            ChooseImageScreenView()
                .environmentObject(photoEditorNavigationViewModel)
                .navigationDestination(for: PhotoEditorNavigationPath.self) { path in
                    switch path {
                    case .profile:
                        ProfileScreenView()
                            .environmentObject(photoEditorNavigationViewModel)
                    case .changeImage(let image):
                        ChangeImageScreenView(backgroundImage: image)
                            .environmentObject(photoEditorNavigationViewModel)
                    }
                }
        }
    }
}

#Preview {
    PhotoEditorRootView()
}

//
//  PhotoEditorNavigationViewModel.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import Foundation
import UIKit

enum PhotoEditorNavigationPath : Hashable {
    case profile
    case changeImage(image: UIImage)
}

class PhotoEditorNavigationViewModel: ObservableObject {
    @Published var path : [PhotoEditorNavigationPath] = []
    
    func navigateToProfile() {
        path.append(.profile)
    }
    
    func navigateToChangeImage(image: UIImage) {
        path.append(.changeImage(image: image))
    }
    
    func goBack() {
        guard path.count > 0 else { return }
        
        path.removeLast()
    }
}

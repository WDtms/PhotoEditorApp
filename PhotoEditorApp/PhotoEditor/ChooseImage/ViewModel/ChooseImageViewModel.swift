//
//  ChooseImageViewModel.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 11.08.2024.
//

import Foundation
import SwiftUI
import PhotosUI

class ChooseImageViewModel: ObservableObject {
    var photoEditorNavigationViewModel : PhotoEditorNavigationViewModel?
    
    func handleSelectedLoadedImage(image: UIImage) {
        photoEditorNavigationViewModel?.navigateToChangeImage(image: image)
    }
    
    func handleSelectedImageToLoad(photoPickerModel: PhotosPickerItem?) {
        guard let photoPickerModel = photoPickerModel else { return }
        
        Task {
            if let data = try? await photoPickerModel.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                
                photoEditorNavigationViewModel?.navigateToChangeImage(image: uiImage)
            }
        }
    }
}

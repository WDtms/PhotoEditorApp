//
//  ChooseImageScreenView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import SwiftUI
import PhotosUI

struct ChooseImageScreenView: View {
    
    @StateObject private var chooseImageViewModel: ChooseImageViewModel = ChooseImageViewModel()
    
    @EnvironmentObject private var photoEditorNavigationViewModel: PhotoEditorNavigationViewModel
    
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        HStack {
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                VStack {
                    Image(systemName: "photo.on.rectangle")
                        .commonImageStyle()
                    
                    Text("From Gallery")
                }
                .padding()
                .foregroundColor(.blue)
                .overlay(
                     RoundedRectangle(cornerRadius: 16)
                         .stroke(Color.blue, lineWidth: 2)
                 )
            }
            .onChange(of: selectedItem, initial: false, { oldValue, newValue in
                chooseImageViewModel.handleSelectedImageToLoad(photoPickerModel: newValue)
            })
            
            Spacer()
                .frame(width: 40)
            
            ImagePicker { uiImage in
                chooseImageViewModel.handleSelectedLoadedImage(image: uiImage)
            } label: {
                VStack {
                    Image(systemName: "camera")
                        .commonImageStyle()
                    
                    Text("From Camera")
                }
                .padding()
                .foregroundColor(.blue)
                .overlay(
                     RoundedRectangle(cornerRadius: 16)
                         .stroke(Color.blue, lineWidth: 2)
                 )
            }

        }
        .padding()
        .navigationTitle("Choose Image")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(
                    action: {
                        photoEditorNavigationViewModel.navigateToProfile()
                    },
                    label: {
                        UserAvatarView()
                    }
                )
            }
        })
        .onAppear {
            chooseImageViewModel.photoEditorNavigationViewModel = photoEditorNavigationViewModel
        }
    }
}

fileprivate extension Image {
    func commonImageStyle() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
    }
}

#Preview {
    ChooseImageScreenView()
}

//
//  ImagePickerButton.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import SwiftUI

struct ImagePicker<Content: View>: View {

    let action: (UIImage) -> Void
    let label: () -> Content
    
    @State private var showImagePicker: Bool = false
    
    var body: some View {
        Button {
            showImagePicker = true
        } label: {
            label()
        }
        .sheet(isPresented: $showImagePicker, content: {
            ImagePickerView(sourceType: .camera, action: action)
        })
    }
}

#Preview {
    ImagePicker { image in
        
    } label: {
        Text("Label")
    }

}

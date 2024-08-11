//
//  TextFieldModifier.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 06.08.2024.
//

import SwiftUI

protocol CustomTextFieldCompatible {}

extension TextField: CustomTextFieldCompatible {}
extension SecureField: CustomTextFieldCompatible {}

extension View where Self: CustomTextFieldCompatible {
    func customTextFieldStyle() -> some View {
        self.modifier(TextFieldModifier())
    }
}

struct TextFieldModifier: ViewModifier {
    @FocusState private var isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .padding()
            .lineLimit(1)
            .frame(height: 50)
            .focused($isFocused)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? Color.customDarkGray : Color.customGray, lineWidth: 1)
            )
    }
}

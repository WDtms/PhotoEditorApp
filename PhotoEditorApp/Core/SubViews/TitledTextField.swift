//
//  TitledTextField.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 06.08.2024.
//

import SwiftUI

struct TitledTextField<HelperView: View>: View {
    let title: String
    let hint: String
    let submitLabel: SubmitLabel
    let isSecure: Bool
    let helperButton: HelperView?
    let errorText: String?
    let isDisabled: Bool
    
    @Binding var text: String
    
    init(title: String, hint: String, text: Binding<String>, submitLabel: SubmitLabel = .done, isSecure: Bool = false, errorText: String? = nil, isDisabled: Bool = false, helperButton: HelperView? = nil) {
        self.title = title
        self.hint = hint
        self.submitLabel = submitLabel
        self.isSecure = isSecure
        self.helperButton = helperButton
        self.errorText = errorText
        self._text = text
        self.isDisabled = isDisabled
    }
    
    init(title: String, hint: String, text: Binding<String>, submitLabel: SubmitLabel = .done, isSecure: Bool = false, errorText: String? = nil, isDisabled: Bool = false) where HelperView == EmptyView {
        self.title = title
        self.hint = hint
        self.submitLabel = submitLabel
        self.isSecure = isSecure
        self.helperButton = nil
        self.errorText = errorText
        self._text = text
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if (helperButton != nil) {
                HStack {
                    Text(title)
                    
                    Spacer()
                    
                    helperButton
                }
                
            } else {
                Text(title)
            }
            
            Spacer().frame(height: 12)
            
            if (isSecure) {
                SecureField(hint, text: $text)
                    .customTextFieldStyle()
                    .submitLabel(submitLabel)
                    .disabled(isDisabled)
                
            } else {
                TextField(hint, text: $text)
                    .customTextFieldStyle()
                    .submitLabel(submitLabel)
                    .disabled(isDisabled)
                
            }
            
            if let errorText = errorText {
                Text(errorText)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}


#Preview {
    @State var text = ""
    
    return TitledTextField(title: "Email Address", hint: "hello@example.com", text: $text)
}

//
//  AppButton.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 08.08.2024.
//

import SwiftUI

struct AppButton: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool
    let isDisabled: Bool
    
    init(title: String, action: @escaping () -> Void, isLoading: Bool = false, isDisabled: Bool = false) {
        self.title = title
        self.action = action
        self.isLoading = isLoading
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            innerBody
                .frame(maxWidth: .infinity, minHeight: 50)
                .foregroundStyle(Color(UIColor.systemBackground))
                .background(Color(UIColor.label))
                .cornerRadius(8)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    @ViewBuilder
    private var innerBody: some View {
        if (isLoading) {
            ProgressView()
        } else {
            Text(title)
        }
    }
}

#Preview {
    AppButton(title: "Sign In", action: {})
}

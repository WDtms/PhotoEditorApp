//
//  GoogleFooter.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 06.08.2024.
//

import SwiftUI

struct GoogleFooterView: View {
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            line
            Text("or sign in with")
                .foregroundColor(.gray)
                .font(.caption)
            line
        }
        
        Spacer().frame(height: 20)
        
        Button(
            action: {
                action()
            }, label: {
                HStack {
                    Image(AppIcons.googleLogo)
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                    Text("Continue with Google")
                        .foregroundColor(Color.customDarkGray)
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(8)
            }
        )
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    var line: some View {
        VStack { Divider().background(Color.gray) }
            .frame(height: 1)
    }
}

#Preview {
    GoogleFooterView(isDisabled: false) {}
}

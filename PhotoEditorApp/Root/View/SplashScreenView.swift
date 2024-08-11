//
//  SplashScreen.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        Image(AppIcons.appLogo)
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
    }
}

#Preview {
    SplashScreenView()
}

//
//  PhotoEditorAppApp.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 06.08.2024.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct PhotoEditorApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootScreenView()
                .onOpenURL(perform: { url in
                    GIDSignIn.sharedInstance.handle(url)
                })
        }
    }
}

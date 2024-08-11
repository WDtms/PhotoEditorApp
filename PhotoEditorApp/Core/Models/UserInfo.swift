//
//  UserInfo.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import Foundation
import SwiftUI

struct UserInfo {
    let userAvatarUrl: URL?
    let userEmail: String?
    
    init(email: String?, avatarUrl: URL?) {
        self.userEmail = email
        self.userAvatarUrl = avatarUrl
    }
}

private struct UserInfoKey: EnvironmentKey {
    static let defaultValue: UserInfo = UserInfo(email: "", avatarUrl: nil)
}

extension EnvironmentValues {
    var userInfo: UserInfo {
        get { self[UserInfoKey.self] }
        set { self[UserInfoKey.self] = newValue }
    }
}

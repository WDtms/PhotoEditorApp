//
//  UserAvatarView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import SwiftUI

struct UserAvatarView: View {
    let diameter: CGFloat
    
    init(diameter: CGFloat = 40) {
        self.diameter = diameter
    }
    
    @Environment(\.userInfo) private var userInfo: UserInfo
    
    var body: some View {
        if let photoURL = userInfo.userAvatarUrl {
            AsyncImage(url: photoURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: diameter, height: diameter)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.gray)
                    .frame(width: diameter, height: diameter)
            }
        } else {
            let initial = userInfo.userEmail?.first?.uppercased() ?? "?"
            Text(initial)
                .font(.system(size: diameter * 0.6))
                .foregroundColor(.white)
                .frame(width: diameter, height: diameter)
                .background(Circle().fill(Color.blue))
        }
    }
}

#Preview {
    UserAvatarView()
}

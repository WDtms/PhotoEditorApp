//
//  TextOverlay.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 11.08.2024.
//

import Foundation
import SwiftUI

struct TextOverlay: Identifiable {
    let id = UUID()
    var text: String = "New Text"
    var position: CGPoint = CGPoint(x: 100, y: 100)
    var font: UIFont = UIFont.systemFont(ofSize: 24)
    var color: UIColor = UIColor.white
}

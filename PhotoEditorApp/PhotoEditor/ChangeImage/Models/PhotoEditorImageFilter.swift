//
//  PhotoEditorImageFilter.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 11.08.2024.
//

import Foundation
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

enum PhotoEditorImageFilter: String, CaseIterable {
    case none = "No Filters"
    case sepia = "Sepia"
    case noir = "Noir"
    case photoEffectTransfer = "Vintage"
    
    func filterFromEnum() -> CIFilter {
        switch self {
        case .none:
            return CIFilter(name: "CIColorControls")!
        case .sepia:
            return CIFilter.sepiaTone()
        case .noir:
            return CIFilter.photoEffectNoir()
        case .photoEffectTransfer:
            return CIFilter.photoEffectTransfer()
        }
    }
}

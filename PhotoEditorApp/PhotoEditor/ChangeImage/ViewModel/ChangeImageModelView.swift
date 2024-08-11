//
//  ChangeImageModelView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import SwiftUI
import PencilKit

class ChangeImageViewModel: ObservableObject {
    @Published var selectedFilter: PhotoEditorImageFilter = .none
    @Published var textOverlays: [TextOverlay] = []
    @Published var filteredImage: UIImage?
    
    private let context = CIContext()

    func applyFilter(to image: UIImage) {
        let ciFilter = selectedFilter.filterFromEnum()
        
        guard var ciImage = CIImage(image: image) else { return }
        switch image.imageOrientation {
        case .up:
            break
        case .down:
            ciImage = ciImage.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.down.rawValue))
        case .left:
            ciImage = ciImage.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.left.rawValue))
        case .right:
            ciImage = ciImage.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.right.rawValue))
        default:
            break
        }
        
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = ciFilter.outputImage,
              let finalCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        filteredImage = UIImage(cgImage: finalCGImage)
    }
    
    private func ciImageWithCorrectOrientation(image: UIImage) -> CIImage? {
        return CIImage(image: image)?.oriented(forExifOrientation: Int32(image.imageOrientation.rawValue))
    }
    
    func addNewTextOverlay() {
        guard textOverlays.isEmpty else { return }
        let newOverlay = TextOverlay()
        textOverlays.append(newOverlay)
    }
    
    func removeTextOverlay() {
        guard !textOverlays.isEmpty else { return }
        textOverlays.removeLast()
    }
    
    func generateExportImage(backgroundImage: UIImage, canvasView: PKCanvasView, completion: @escaping (UIImage) -> Void) {
        let canvasBounds = canvasView.bounds
        let drawing = canvasView.drawing

        DispatchQueue.global(qos: .userInitiated).async {
            let renderer = UIGraphicsImageRenderer(size: canvasBounds.size)
            let image = renderer.image { ctx in
                let imageRect = CGRect(
                    x: 0,
                    y: (canvasBounds.height - canvasBounds.width * (backgroundImage.size.height / backgroundImage.size.width)) / 2,
                    width: canvasBounds.width,
                    height: canvasBounds.width * (backgroundImage.size.height / backgroundImage.size.width)
                )
                
                backgroundImage.draw(in: imageRect)
                drawing.image(from: canvasBounds, scale: 1.0).draw(in: canvasBounds)
                
                for overlay in self.textOverlays {
                    let textAttributes: [NSAttributedString.Key: Any] = [
                        .font: overlay.font,
                        .foregroundColor: overlay.color
                    ]
                    
                    let attributedText = NSAttributedString(string: overlay.text, attributes: textAttributes)
                    let textSize = attributedText.size()
                    let adjustedPosition = CGPoint(
                        x: overlay.position.x - textSize.width / 2,
                        y: overlay.position.y - textSize.height / 2
                    )
                    
                    attributedText.draw(at: adjustedPosition)
                }
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}

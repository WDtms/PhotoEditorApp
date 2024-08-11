//
//  CanvasView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    let toolPicker = PKToolPicker()
      
      func makeUIView(context: Context) -> PKCanvasView {
          canvasView.drawingPolicy = .anyInput
          canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
          canvasView.isOpaque = false
          canvasView.backgroundColor = .clear

          toolPicker.setVisible(true, forFirstResponder: canvasView)
          toolPicker.addObserver(canvasView)
          DispatchQueue.main.async {
              canvasView.becomeFirstResponder()
          }

          return canvasView
      }
      
      func updateUIView(_ uiView: PKCanvasView, context: Context) {
      }
      
      func makeCoordinator() -> Coordinator {
          Coordinator(self)
      }
      
      class Coordinator: NSObject, PKCanvasViewDelegate {
          var parent: CanvasView
          
          init(_ parent: CanvasView) {
              self.parent = parent
          }
      }
}

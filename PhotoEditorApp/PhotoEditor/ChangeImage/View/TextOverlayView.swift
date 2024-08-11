//
//  TextOverlayView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 11.08.2024.
//

import SwiftUI

struct TextOverlayView: View {
    
    @EnvironmentObject private var changeImageViewModel: ChangeImageViewModel
    @State private var showTextEdit: Bool = false
    
    @State private var dragOffset: CGSize = .zero
    @Binding var overlay: TextOverlay
    
    var body: some View {
        Text(overlay.text)
            .font(Font(overlay.font))
            .foregroundColor(Color(overlay.color))
            .contextMenu(ContextMenu(menuItems: {
                Button("Configure") {
                    showTextEdit = true
                }
                Button("Delete") {
                    changeImageViewModel.removeTextOverlay()
                }
            }))
            .position(x: overlay.position.x + dragOffset.width, y: overlay.position.y + dragOffset.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        overlay.position.x += dragOffset.width
                        overlay.position.y += dragOffset.height
                        dragOffset = .zero
                    }
            )
            .sheet(isPresented: $showTextEdit) {
                TextEditingView(overlay: $overlay)
            }
    }
}

//#Preview {
//    TextOverlayView(overlay: <#T##Binding<TextOverlay>#>)
//}

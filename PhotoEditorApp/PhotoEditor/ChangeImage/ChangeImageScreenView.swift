//
//  ChangeImageScreenView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import SwiftUI
import PencilKit

struct ChangeImageScreenView: View {
    let backgroundImage: UIImage
    @StateObject private var viewModel = ChangeImageViewModel()
    @State private var canvasView = PKCanvasView()

    var body: some View {
        ZStack {
            if let filteredImage = viewModel.filteredImage {
                Image(uiImage: filteredImage)
                    .resizable()
                    .scaledToFit()
            }
            
            CanvasView(canvasView: $canvasView)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
            
            ForEach($viewModel.textOverlays) { $overlay in
                TextOverlayView(overlay: $overlay)
                    .environmentObject(viewModel)
            }
        }
        .navigationTitle("Changing Image")
        .toolbar {
            ToolbarItem(placement: .topBarLeading, content: {
                Picker("Filter", selection: $viewModel.selectedFilter) {
                    ForEach(PhotoEditorImageFilter.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: viewModel.selectedFilter, initial: true) {
                    viewModel.applyFilter(to: backgroundImage)
                }
            })
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    viewModel.addNewTextOverlay()
                }) {
                    Text("Add Text")
                }
                .disabled(!viewModel.textOverlays.isEmpty)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.generateExportImage(backgroundImage: backgroundImage, canvasView: canvasView) { image in
                        self.exportDrawing(image: image)
                    }
                } label: {
                    Text("Export")
                }
            }
        }
    }
    
    private func exportDrawing(image: UIImage) {
        if let topVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController {
            topVC.present(UIActivityViewController(activityItems: [image], applicationActivities: nil), animated: true)
        }
    }
}

#Preview {
    ChangeImageScreenView(backgroundImage: UIImage())
}

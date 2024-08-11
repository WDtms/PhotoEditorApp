//
//  TextEditingView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 11.08.2024.
//

import SwiftUI

struct TextEditingView: View {
    @Binding var overlay: TextOverlay
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedFontSize: CGFloat = 24
    @State private var selectedColor: UIColor = .white
    @State private var editedText: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Text")) {
                    TextField("Text", text: $editedText)
                        .onAppear {
                            self.editedText = overlay.text
                            self.selectedFontSize = overlay.font.pointSize
                            self.selectedColor = overlay.color
                        }
                        .onChange(of: editedText, initial: false) { _, newValue in
                            overlay.text = newValue
                        }
                }
                
                Section(header: Text("Font Size")) {
                    Slider(value: $selectedFontSize, in: 10...100, step: 1) {
                        Text("Font Size")
                    }
                    .onChange(of: selectedFontSize, initial: false) { _, newValue in
                        overlay.font = overlay.font.withSize(newValue)
                    }
                }
                
                Section(header: Text("Text Color")) {
                    ColorPicker("Select Color", selection: Binding(
                        get: { Color(selectedColor) },
                        set: { newValue in
                            selectedColor = UIColor(newValue)
                            overlay.color = selectedColor
                        }
                    ))
                }
            }
            .navigationBarTitle("Edit Text", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

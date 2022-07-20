//
//  CameraPickerRepresentable.swift
//  ImageCropper
//
//  Created by 鶴本賢太朗 on 2022/07/15.
//

import SwiftUI

struct CameraPickerRepresentable: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    let onDismiss: () -> Void
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPickerRepresentable
        
        init(_ parent: CameraPickerRepresentable) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                
                UIImageWriteToSavedPhotosAlbum(uiImage, uiImage, nil, nil)
            }
            
            picker.dismiss(animated: true) { [weak self] in
                self?.parent.onDismiss()
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) { [weak self] in
                self?.parent.onDismiss()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPickerRepresentable>) -> UIImagePickerController {
        let picker: UIImagePickerController = .init()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraPickerRepresentable>) {
    }
}


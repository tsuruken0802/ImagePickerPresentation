//
//  ImageCropperRepresentable.swift
//  ImageCropper
//
//  Created by 鶴本賢太朗 on 2022/07/15.
//

import SwiftUI
import CropViewController

struct ImageCropperRepresentable: UIViewControllerRepresentable {
    @Binding var circularImage: UIImage?
    let originalImage: UIImage
    let onDismiss: () -> Void
    let croppingStyle: CropViewCroppingStyle
    let cropBoxResizeEnabled: Bool
    
    class Coordinator: NSObject, CropViewControllerDelegate {
        let parent: ImageCropperRepresentable
        
        init(_ parent: ImageCropperRepresentable) {
            self.parent = parent
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            parent.circularImage = image
            cropViewController.dismiss(animated: true) { [weak self] in
                self?.parent.onDismiss()
            }
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            parent.circularImage = image
            cropViewController.dismiss(animated: true) { [weak self] in
                self?.parent.onDismiss()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageCropperRepresentable>) -> CropViewController {
        let cropController: CropViewController = .init(croppingStyle: croppingStyle, image: originalImage)
        cropController.delegate = context.coordinator
        
        cropController.aspectRatioPickerButtonHidden = true
        cropController.resetAspectRatioEnabled = false
        cropController.rotateButtonsHidden = false
        cropController.cropView.cropBoxResizeEnabled = cropBoxResizeEnabled
        cropController.cropView.aspectRatioLockDimensionSwapEnabled = true
        return cropController
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: UIViewControllerRepresentableContext<ImageCropperRepresentable>) {

    }
}


//
//  ImagePickerPresentation.swift
//  ImageCropper
//
//  Created by 鶴本賢太朗 on 2022/07/15.
//

import SwiftUI
import CropViewController

public struct ImagePickerPresentation: Identifiable {
    public enum Presentation: View {
        
        // ImagePicker
        case camera(image: Binding<UIImage?>,
                    onDismiss: () -> Void)
        
        // PHPicker
        case phpicker(pickedImages: Binding<[UIImage]>,
                      selectionLimit: Int,
                      onDismiss: () -> Void)
        
        // Cropper
        case cropper(image: Binding<UIImage?>,
                     originalImage: UIImage,
                     croppingStyle: CropViewCroppingStyle,
                     cropSize: CGSize,
                     onDismiss: () -> Void)
        
        public var body: some View {
            switch self {
            case .camera(let image, let onDismiss):
                return AnyView(CameraPickerRepresentable(image: image, onDismiss: onDismiss))
                
            case .phpicker(let pickedImages, let selectionLimit, let onDismiss):
                return AnyView(PHPickerRepresentable(selectionLimit: selectionLimit,
                                                     pickedImages: pickedImages,
                                                     onDismiss: onDismiss))
                
            case .cropper(let image, let originalImage, let croppingStyle, let cropSize, let onDismiss):
                return AnyView(ImageCropperRepresentable(circularImage: image,
                                            originalImage: originalImage,
                                            onDismiss: onDismiss,
                                            croppingStyle: croppingStyle,
                                            cropSize: cropSize))
            }
        }
    }
    
    public var id: String = UUID().uuidString
    
    public var presentation: Presentation?
    
    public init(presentation: Presentation?) {
        self.presentation = presentation
    }
}

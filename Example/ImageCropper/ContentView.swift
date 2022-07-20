//
//  ContentView.swift
//  ImageCropper
//
//  Created by 鶴本賢太朗 on 2022/07/15.
//

import SwiftUI
import ImagePickerPresentation

struct ContentView: View {
    // PHPickerのfullScreenの固有データ
    @State private var presentation: ImagePickerPresentation?
    
    // ImagePicker側でbindする画像
    @State private var bindingImagePickerImage: UIImage?
    
    // PHPicker側でbindする画像一覧
    @State private var bindingPhPickerImages: [UIImage] = []
    
    // cropする画像
    @State private var bindingCroppedImage: UIImage?
    
    // 表示用の画像データ
    @State private var images: [ImageData] = []
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    presentation = .init(presentation: .phpicker(pickedImages: $bindingPhPickerImages, selectionLimit: 1, onDismiss: {
                        guard let image = bindingPhPickerImages.first else { return }
                        presentation = .init(presentation: .cropper(image: $bindingCroppedImage, originalImage: image, croppingStyle: .default, cropSize: .init(width: 200, height: 200), onDismiss: {
                            images = [ImageData(image: bindingCroppedImage!)]
                        }))
                    }))
                }, label: {
                    Text("PHPicker")
                })
                
                Button(action: {
                    presentation = ImagePickerPresentation(presentation: .camera(image: $bindingImagePickerImage, onDismiss: {
                        guard let pickedImage: UIImage = bindingImagePickerImage else { return }
                        presentation = .init(presentation: .cropper(image: $bindingCroppedImage,
                                                                    originalImage: pickedImage,
                                                                    croppingStyle: .default,
                                                                    cropSize: .init(width: 200, height: 200),
                                                                    onDismiss: {
                            images = [ImageData(image: bindingCroppedImage!)]
                        }))
                    }))
                }, label: {
                    Text("ImagePicker")
                })
            }

            .fullScreenCover(item: $presentation) { $0.presentation }
            
            List {
                ForEach(images) { imageData in
                    Image(uiImage: imageData.image)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ImageData: Identifiable {
    let id: String = UUID().uuidString
    let image: UIImage
}

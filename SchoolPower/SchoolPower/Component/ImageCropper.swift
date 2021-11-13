//
//  ImageCropper.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/13/21.
//

import SwiftUI
import CropViewController

struct ImageCropper: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var croppedImage: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, CropViewControllerDelegate {
        let parent: ImageCropper

        init(_ parent: ImageCropper) {
            self.parent = parent
        }
        
        func cropViewController(_ cropViewController: CropViewController,
                                didCropToCircularImage image: UIImage,
                                withRect cropRect: CGRect, angle: Int) {
            parent.croppedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageCropper>) -> CropViewController {
        let cropper = CropViewController(croppingStyle: .circular, image: image!)
        self.image = nil
        cropper.delegate = context.coordinator
        return cropper
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {
        
    }
}

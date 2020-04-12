//
//  SelectPhotoHelper.swift
//  Dexter
//
//  Created by Sunchit Anand on 3/22/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit

class SelectPhotoHelper: NSObject {
    
    // MARK: - Properties
    
    var completionHandler: ((UIImage) -> Void)?
    
    // MARK: - Helper Methods
    
    func presentActionSheet(from viewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your photo from?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
                print("Camera opened")
                self.presentImagePickerController(with: .camera, from: viewController)
            }
            alertController.addAction(capturePhotoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default) { (action) in
                print("Gallery opened")
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
            }
            alertController.addAction(uploadAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
    
    func presentImagePickerController(with sourceType: UIImagePickerController.SourceType, from viewController: UIViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)

        viewController.present(imagePickerController, animated: true)
    }
    
}

extension SelectPhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /// called when image is selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            completionHandler?(selectedImage)
        }

        picker.dismiss(animated: true)
    }
    /// called when cancel is pressed
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


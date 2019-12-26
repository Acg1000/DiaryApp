//
//  PhotoPickerManager.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/22/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//
//  FUNCTION: Manages the delegate methods for picking photos from the camera and library

import UIKit
import MobileCoreServices
import CoreGraphics

class PhotoPickerManager: NSObject {
    private let imagePickerController = UIImagePickerController()
    private let presentingController: UIViewController
    private weak var delegate: PhotoPickerManagerDelegate?
    
    init(presentingViewController: UIViewController, delegate: PhotoPickerManagerDelegate) {
        self.presentingController = presentingViewController
        self.delegate = delegate
        super.init()
                
    }
    
    func presentPhotoPicker(animated: Bool, for sourceType: UIImagePickerController.SourceType) {
        configure(for: sourceType)
        
        presentingController.present(imagePickerController, animated: animated, completion: nil)
    }
    
    func dismissPhotoPicker(animated: Bool, completion: (() -> Void)?) {
        imagePickerController.dismiss(animated: animated, completion: completion)
    }
    
    
    private func configure(for sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePickerController.sourceType = sourceType
        }
        
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.delegate = self
    }
    
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        if image != nil {
            self.delegate?.didSelect(image: image)

        }
        
        self.delegate?.didSelect(image: image)
    }
}


// MARK: PhotoPickerManagerDelegate

protocol PhotoPickerManagerDelegate: class {
    func didSelect(image: UIImage?)
}


// MARK: PhotoPickerManager

extension PhotoPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        
        self.pickerController(picker, didSelect: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
}

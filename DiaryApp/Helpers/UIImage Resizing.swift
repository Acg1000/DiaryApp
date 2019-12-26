//
//  UIImage Resizing.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/23/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//
//  FUNCTION: adds methods that allow for modification of UIImages

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.size.width, height: self.size.height))
        
        let cgImageCropped = self.cgImage?.cropping(to: rect)
        let croppedImage = UIImage(cgImage: cgImageCropped!)

        return croppedImage
    }
    
    func resizeAndRotate(to size: CGSize, withOrientation orientation: UIImage.Orientation) -> UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.size.width, height: self.size.height))
        
        let cgImageCropped = self.cgImage?.cropping(to: rect)
        let croppedImage = UIImage(cgImage: cgImageCropped!, scale: 1.0, orientation: .right)

        return croppedImage
    }
    
    func rotate(withOrientation orientation: UIImage.Orientation) -> UIImage? {
        return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .right)
    }
}

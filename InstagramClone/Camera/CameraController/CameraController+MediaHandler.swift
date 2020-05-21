//
//  CameraController+MediaHandler.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/18/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import Foundation
import Photos
import UIKit
extension CameraController: MediaContainerDelegate {
    func handleDismissMedia() {
        updateUiForCamera()
    }

    func handleSaveMedia() {
        let library = PHPhotoLibrary.shared()
        if !previewImageView.isHidden {
            guard let image = previewImageView.image else { return }
            library.performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { (_, err) in
                if let err = err {
                    print("Failed to save image to photo library: ", err)
                    return
                }
                DispatchQueue.main.async {
                    self.showSavedMediaPopup()
                }
                print("Image saved successfully")
            }
        } else {
            guard let url = self.videoUrl else { return }
            library.performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }) { (_, err) in
                if let err = err {
                    print("Failed to save video to photo library: ", err)
                    return
                }
                DispatchQueue.main.async {
                    self.showSavedMediaPopup()
                }
                print("video saved successfully")
            }
        }
    }
    
    func showSavedMediaPopup() {
        self.previewView.addSubview(mediaButtonsContainer.savedLabel)
        mediaButtonsContainer.savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
        self.mediaButtonsContainer.savedLabel.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.mediaButtonsContainer.savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.mediaButtonsContainer.savedLabel.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
                self.mediaButtonsContainer.savedLabel.alpha = 0
            }) { (_) in
                self.mediaButtonsContainer.savedLabel.removeFromSuperview()
            }
        }
    }
}

//
//  CameraController+MediaHandler.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/18/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import Foundation
import Photos
extension CameraController: MediaContainerProtocol {
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
                print("video saved successfully")
            }
        }
    }
}

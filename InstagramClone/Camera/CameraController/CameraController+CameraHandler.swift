//
//  CameraController+CameraHandler.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/18/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import Foundation
import AVFoundation

extension CameraController: CameraContainerProtocol {
    func handleCapturePhoto() {
        if videoCounter == 0 {
            let settings = AVCapturePhotoSettings()
            output.capturePhoto(with: settings, delegate: self)
        } else {
            if videoCounter > 1 {
                if movieOutput.isRecording {
                    movieOutput.stopRecording()
                }
            }
        }
        killTimer()
    }
    
    func handleHoldCaptureButton() {
        videoTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("output.mov")
        try? FileManager.default.removeItem(at: fileUrl)
        movieOutput.startRecording(to: fileUrl, recordingDelegate: self as AVCaptureFileOutputRecordingDelegate)
    }

    func handleDismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    func handleSwitchCamera() {
        switchCamera()
    }

}

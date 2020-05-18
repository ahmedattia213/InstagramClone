//
//  CameraController+CameraHandler.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/18/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit
import AVFoundation

extension CameraController: CameraContainerProtocol, ImagePickerDelegate {
    func didSelect(selectedMedia: Any?) {
        if let image = selectedMedia as? UIImage {
            self.updateUiForImagePreview(image: image)
        } else if let videoUrl = selectedMedia as? URL {
            self.updateUiForVideoPreview(url: videoUrl)
        }
    }

    func handleAddMedia() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        imagePicker.present(from: self.view)
    }

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
        toggleTorchAfterCapturing()
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
        let currentCameraInput: AVCaptureInput = captureSession.inputs[0]
        let currentAudioInput: AVCaptureInput = captureSession.inputs[1]
        captureSession.beginConfiguration()
        captureSession.removeInput(currentCameraInput)
        captureSession.removeInput(currentAudioInput)
        var newCamera: AVCaptureDevice! = nil
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            frontCam = !frontCam
            if input.device.position == .back {
                previewImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
                videoPlayer.transform = CGAffineTransform(scaleX: -1, y: 1)
                newCamera = getCameraWithPosition(position: .front)
            } else {
                previewImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                videoPlayer.transform = CGAffineTransform(scaleX: 1, y: 1)
                newCamera = getCameraWithPosition(position: .back)
            }
        }
        var newVideoInput: AVCaptureDeviceInput!
        do {
            newVideoInput = try AVCaptureDeviceInput(device: newCamera)
        } catch let err1 {
            print(err1)
            print("Failed creating capture device input: ", err1)
            return
        }
        captureSession.addInput(newVideoInput)
        captureSession.addInput(currentAudioInput)
        self.videoDevice = newVideoInput.device
        captureSession.commitConfiguration()
    }
    
    @objc func handleToggleFlash() {
        guard let camDevice = self.videoDevice else { return }
        guard camDevice.isTorchAvailable else { print("Flash is not available on this device ") ; return }
        do {
            try camDevice.lockForConfiguration()
            camDevice.torchMode = torchOn ? .off : .on
            torchOn = !torchOn
            cameraButtonsContainer.toggleFlashButton.setImage(UIImage(named: torchOn ? "flash_on" : "flash_off"), for: .normal)
            if camDevice.torchMode == .on {
                try camDevice.setTorchModeOn(level: 1)
            }
        } catch let err {
            print("Failed to turn on/off flash: ", err)
        }
    }
}

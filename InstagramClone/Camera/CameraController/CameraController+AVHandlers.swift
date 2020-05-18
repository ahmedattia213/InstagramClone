//
//  CameraController+Handlers.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/16/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

extension CameraController {

    @objc func handleTapToFocus(tap: UITapGestureRecognizer) {
        guard let videoDevice = self.videoDevice else { return }
        do {
            let pointOfFocus = tap.location(in: previewView)
            try videoDevice.lockForConfiguration()
            if videoDevice.isFocusPointOfInterestSupported && videoDevice.isFocusModeSupported(videoDevice.focusMode) {
                videoDevice.focusPointOfInterest = pointOfFocus
                videoDevice.focusMode = .autoFocus
            }
            if videoDevice.isExposurePointOfInterestSupported && videoDevice.isExposureModeSupported(videoDevice.exposureMode) {
                videoDevice.exposurePointOfInterest = pointOfFocus
                videoDevice.exposureMode = .autoExpose
            }
            showTapFocusIndicator(point: pointOfFocus)
            videoDevice.unlockForConfiguration()
        } catch let err {
            print("Failed to lock for configuration: ", err)
        }
    }

    func getCameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices where device.position == position {
            return device
        }
        return nil
    }

    func setupCaptureSession() {
        //setup Inputs
        guard let videoDevice = AVCaptureDevice.default(for: .video), let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
        self.videoDevice = videoDevice
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)

            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
        } catch let err {
            print("Couldnt setup video device: ", err)
        }

        do {
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }
        } catch let err {
            print("Couldnt setup audio device: ", err)
        }
        //setup outputs
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        //setup output preview
        previewLayer.session = captureSession
        previewLayer.videoGravity = .resizeAspectFill
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    @objc func startTimer() {
        videoCounter += 1
        //        print("This is a second ", videoCounter)
    }

    func killTimer() {
        videoTimer?.invalidate()
        videoTimer = nil
        videoCounter = 0
    }

}

extension CameraController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            self.updateUiForVideoPreview(url: outputFileURL)
        } else {
            print("Failed to complete video recording: ", error as Any)
        }
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let previewImage = UIImage(data: imageData) else { return }
        updateUiForImagePreview(image: previewImage)
    }
}

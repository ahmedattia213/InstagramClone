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

     func switchCamera() {
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
        captureSession.commitConfiguration()
    }
}

extension CameraController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            self.videoUrl = outputFileURL
            self.updateUiForVideoPreview(url: outputFileURL)
            videoPlayer.play()
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

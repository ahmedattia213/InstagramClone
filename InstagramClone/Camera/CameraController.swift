//
//  CameraController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/14/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    let previewLayer = AVCaptureVideoPreviewLayer()
    let captureSession = AVCaptureSession()
    let previewView = UIView()
    
    lazy var capturePhotoButton = UIButton.systemButton( image: UIImage(named: "capture_photo"), target: self, selector: #selector(handleCapturePhoto))
    
    lazy var dismissButton = UIButton.systemButton( image: UIImage(named: "cancel_shadow"), target: self, selector: #selector(handleDismiss))
    
    lazy var switchCamButton = UIButton.systemButton( image: UIImage(named: "flip_camera"), target: self, selector: #selector(handleSwitchCamera))
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc fileprivate func handleCapturePhoto() {
        switchCamera()
    }
    
    @objc fileprivate func handleSwitchCamera() {
        switchCamera()
    }
    @objc fileprivate func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCaptureSession()
    }
    
    fileprivate func setupUI() {
        let topAnchor = view.safeAreaLayoutGuide.topAnchor
        let bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        view.addSubviews(previewView, capturePhotoButton, dismissButton, switchCamButton)
        
        previewView.anchor(topAnchor, left: view.leftAnchor, bottom: bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 60, rightConstant: 0)
        capturePhotoButton.anchor(bottom: previewView.bottomAnchor, bottomConstant: 12, widthConstant: 80, heightConstant: 80, centerXInSuperView: true )
        dismissButton.anchor(previewView.topAnchor, right: previewView.rightAnchor, topConstant: 12, rightConstant: 12, widthConstant: 50, heightConstant: 50)
        switchCamButton.anchor(bottom: bottomAnchor, right: view.rightAnchor, bottomConstant: 0, rightConstant: 12, widthConstant: 60, heightConstant: 60)
        
        switchCamButton.tintColor = .white
        dismissButton.tintColor = .white
        previewView.backgroundColor = .clear
        previewView.layer.masksToBounds = true
        previewView.layer.cornerRadius = 24
    }
    
    fileprivate func setupCaptureSession() {
        //setup Inputs
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let audioInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }
        } catch let err {
            print("Couldnt setup camera input: ", err)
        }

        //setup outputs
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        //setup output preview
        previewLayer.session = captureSession
        previewView.layer.addSublayer(previewLayer)
        previewLayer.videoGravity = .resizeAspectFill
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    @objc fileprivate func switchCamera() {
        //Change camera source
        //Remove existing input
        guard let currentCameraInput: AVCaptureInput = captureSession.inputs.first else {
            return
        }
        
        //Indicate that some changes will be made to the session
        captureSession.beginConfiguration()
        captureSession.removeInput(currentCameraInput)
        
        //Get new input
        var newCamera: AVCaptureDevice! = nil
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            if (input.device.position == .back) {
                newCamera = cameraWithPosition(position: .front)
            } else {
                newCamera = cameraWithPosition(position: .back)
            }
        }
        //Add input to session
        var err: NSError?
        var newVideoInput: AVCaptureDeviceInput!
        do {
            newVideoInput = try AVCaptureDeviceInput(device: newCamera)
        } catch let err1 as NSError {
            err = err1
            newVideoInput = nil
        }
        
        if newVideoInput == nil || err != nil {
            print("Error creating capture device input: \(err?.localizedDescription)")
        } else {
            captureSession.addInput(newVideoInput)
        }
        captureSession.commitConfiguration()
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = previewView.layer.bounds
    }
}

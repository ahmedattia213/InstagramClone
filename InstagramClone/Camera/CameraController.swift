//
//  CameraController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/14/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("hey ",error)
        if error == nil {
            print("I did finish recording and will save to documents")
            self.videoUrl = outputFileURL
            updateUiForVideoPreview(url: outputFileURL)
            videoPlayer.play()
        }
    }
    
    
    let previewLayer = AVCaptureVideoPreviewLayer()
    let captureSession = AVCaptureSession()
    let output = AVCapturePhotoOutput()
    let movieOutput = AVCaptureMovieFileOutput()

    var videoUrl: URL? {
        didSet {
            
        }
    }
    let previewView = UIView()
    var videoTimer: Timer?
    var videoCounter = 0
    
    var frontCam = false
    let previewImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, userInteraction: true)
    
    var videoPlayer: VideoPlayer = VideoPlayer(frame: .zero)
    
    lazy var capturePhotoButton: UIButton = {
        let button = UIButton.systemButton( image: UIImage(named: "capture_photo"), target: self, selector: #selector(handleCapturePhoto))
        button.addTarget(self, action: #selector(holdDownButton), for: .touchDown)
        return button
    }()
    @objc func holdDownButton() {
        print("hold")
        videoTimer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(startTimer), userInfo: nil, repeats: true)
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("output.mov")
        try? FileManager.default.removeItem(at: fileUrl)
        movieOutput.startRecording(to: fileUrl, recordingDelegate: self as AVCaptureFileOutputRecordingDelegate)
    }

    @objc func startTimer() {
        videoCounter += 1
        print("This is a second ", videoCounter)
    }
    
    func killTimer() {
        videoTimer?.invalidate()
        videoTimer = nil
        videoCounter = 0
    }
    

    lazy var dismissViewButton = UIButton.systemButton( image: UIImage(named: "cancel_shadow"), target: self, selector: #selector(handleDismissView))

    lazy var dismissMediaButton = UIButton.systemButton( image: UIImage(named: "cancel_shadow"), target: self, selector: #selector(handleDismissMedia))

    lazy var saveMediaButton = UIButton.systemButton( image: UIImage(named: "save_image"), target: self, selector: #selector(handleSaveMedia))
    lazy var switchCamButton = UIButton.systemButton( image: UIImage(named: "flip_camera"), target: self, selector: #selector(handleSwitchCamera))

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    


    @objc fileprivate func handleSwitchCamera() {
        switchCamera()
    }
    @objc fileprivate func handleDismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDismissMedia() {
        print("dismiss media")
        updateUiForCamera()
    }
    
    @objc func handleSaveMedia() {
        print("Save media")
        let library = PHPhotoLibrary.shared()
        if !previewImageView.isHidden {
            guard let image = previewImageView.image else { return }
            library.performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { (_, err) in
                if let err = err {
                    print("Failed to save image to photo library: ",err)
                    return
                }
                print("image saved successfully")
            }
        } else {
            guard let url = self.videoUrl else { return }
            library.performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }) { (_, err) in
                if let err = err {
                    print("Failed to save video to photo library: ",err)
                    return
                }
                print("video saved successfully")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCaptureSession()
    }
    
    fileprivate func setupUI() {
        let topAnchor = view.safeAreaLayoutGuide.topAnchor
        let bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        view.addSubviews(previewView, capturePhotoButton, dismissViewButton, switchCamButton, dismissMediaButton, saveMediaButton)
        previewView.addSubview(previewImageView)
        previewView.addSubview(videoPlayer)
        updateUiForCamera()
        setupPreviewImageView()
        setupAfterCaptureViews()
        setupVideoPlayer()
        previewView.anchor(topAnchor, left: view.leftAnchor, bottom: bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 60, rightConstant: 0)
        capturePhotoButton.anchor(bottom: previewView.bottomAnchor, bottomConstant: 12, widthConstant: 80, heightConstant: 80, centerXInSuperView: true )
        dismissViewButton.anchor(previewView.topAnchor, right: previewView.rightAnchor, topConstant: 12, rightConstant: 12, widthConstant: 50, heightConstant: 50)
        switchCamButton.anchor(bottom: bottomAnchor, right: view.rightAnchor, bottomConstant: 0, rightConstant: 12, widthConstant: 60, heightConstant: 60)
        setupPreviewImageView()
        switchCamButton.tintColor = .white
        dismissViewButton.tintColor = .white
        previewView.backgroundColor = .clear
        previewView.layer.masksToBounds = true
        previewView.layer.cornerRadius = 24
    }

    private func setupPreviewImageView() {
        previewImageView.fillSuperview()
    }
    
    private func setupVideoPlayer() {
        videoPlayer.fillSuperview()
    }
    private func setupAfterCaptureViews() {
        dismissMediaButton.tintColor = .white
        saveMediaButton.tintColor = .white
        dismissMediaButton.anchor(previewView.topAnchor, left: previewView.leftAnchor, topConstant: 12, leftConstant: 12, widthConstant: 50, heightConstant: 50)
        saveMediaButton.anchor(previewView.topAnchor, topConstant: 12, widthConstant: 50, heightConstant: 50, centerXInSuperView: true )
    }
    @objc fileprivate func handleCapturePhoto() {
        if videoCounter == 0 {
            print("Captured the image")
            let settings = AVCapturePhotoSettings()
            output.capturePhoto(with: settings, delegate: self)
        } else {
            if videoCounter > 1 {
                print("Captured the video")
                if movieOutput.isRecording {
                movieOutput.stopRecording()
                }
            }
        }
        killTimer()

       
    }


    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let previewImage = UIImage(data: imageData) else { return }
        updateUiForImagePreview(image: previewImage)
    }

    private func updateUiForImagePreview(image: UIImage) {
        previewImageView.image = image
        previewImageView.isHidden = false
        videoPlayer.isHidden = true
        dismissMediaButton.isHidden = false
        saveMediaButton.isHidden = false
        capturePhotoButton.isHidden = true
        dismissViewButton.isHidden = true
        switchCamButton.isHidden = true
        previewLayer.removeFromSuperlayer()
    }
    
    private func updateUiForVideoPreview(url: URL) {
        previewLayer.removeFromSuperlayer()
//        videoPlayer = VideoPlayer(videoUrl: url, frame: previewView.layer.bounds)
        videoPlayer.videoURL = url
        videoPlayer.isHidden = false
    
        previewImageView.image = nil
        previewImageView.isHidden = true
        dismissMediaButton.isHidden = false
        saveMediaButton.isHidden = false
        capturePhotoButton.isHidden = true
        dismissViewButton.isHidden = true
        switchCamButton.isHidden = true
    }

    private func updateUiForCamera() {
        videoPlayer.isHidden = true
        previewImageView.image = nil
        previewView.layer.addSublayer(previewLayer)
        previewImageView.isHidden = true
        capturePhotoButton.isHidden = false
        dismissViewButton.isHidden = false
        switchCamButton.isHidden = false
        dismissMediaButton.isHidden = true
        saveMediaButton.isHidden = true
    }
    
    fileprivate func setupCaptureSession() {
        //setup Inputs
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
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
            frontCam = !frontCam
            if (input.device.position == .back) {
                previewImageView.transform = CGAffineTransform(scaleX: -1, y: 1);
                videoPlayer.transform = CGAffineTransform(scaleX: -1, y: 1);
                newCamera = cameraWithPosition(position: .front)
            } else {
                previewImageView.transform = CGAffineTransform(scaleX: 1, y: 1);
                videoPlayer.transform = CGAffineTransform(scaleX: 1, y: 1);
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
        videoPlayer.frame = previewView.layer.bounds
    }
}

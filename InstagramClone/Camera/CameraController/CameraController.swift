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
class CameraController: UIViewController {
    
    //UI Components
    let cameraButtonsContainer = CameraButtonsContainer()
    let mediaButtonsContainer = MediaButtonsContainer()
    let previewImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, userInteraction: true)
    var videoPlayer: VideoPlayer = VideoPlayer(frame: .zero)
    let previewView = UIView()
    
    //AV Components
    let previewLayer = AVCaptureVideoPreviewLayer()
    let captureSession = AVCaptureSession()
    let output = AVCapturePhotoOutput()
    let movieOutput = AVCaptureMovieFileOutput()
    
    //Logic helpers
    var frontCam = false
    var videoUrl: URL?
    var videoTimer: Timer?
    var videoCounter = 0 {
        didSet {
            if videoCounter >= 10 {
                if movieOutput.isRecording {
                    movieOutput.stopRecording()
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButtonsContainer.delegate = self
        mediaButtonsContainer.delegate = self
        setupUI()
        setupCaptureSession()
    }
    
    fileprivate func setupUI() {
        let topAnchor = view.safeAreaLayoutGuide.topAnchor
        let bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        view.addSubviews(previewView)
        previewView.addSubviews(previewImageView, videoPlayer)
        previewImageView.fillSuperview()
        videoPlayer.fillSuperview()
        updateUiForCamera()
        previewView.anchor(topAnchor, left: view.leftAnchor, bottom: bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 60, rightConstant: 0)
        previewView.backgroundColor = .clear
        previewView.layer.masksToBounds = true
        previewView.layer.cornerRadius = 24
    }
    
    func updateUiForCamera() {
        videoPlayer.isHidden = true
        videoPlayer.stop()
        previewImageView.image = nil
        previewImageView.isHidden = true
        previewView.layer.addSublayer(previewLayer)
        previewView.addSubview(cameraButtonsContainer)
        mediaButtonsContainer.removeFromSuperview()
        cameraButtonsContainer.fillSuperview()
    }
    
    func updateUiForImagePreview(image: UIImage) {
        updateUiForImageAndVideo()
        previewImageView.image = image
        previewImageView.isHidden = false
        videoPlayer.isHidden = true
    }
    
    func updateUiForVideoPreview(url: URL) {
        updateUiForImageAndVideo()
        videoPlayer.videoURL = url
        videoPlayer.isHidden = false
        previewImageView.image = nil
        previewImageView.isHidden = true
        
    }
    
    func updateUiForImageAndVideo() {
        previewLayer.removeFromSuperlayer()
        cameraButtonsContainer.removeFromSuperview()
        previewView.addSubview(mediaButtonsContainer)
        mediaButtonsContainer.fillSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = previewView.layer.bounds
    }
}

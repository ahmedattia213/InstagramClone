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
class CameraController: UIViewController, UIViewControllerTransitioningDelegate {
    
    //UI Components
    let tapImage = UIImageView(image: UIImage(named: "empty_circle"))
    let cameraButtonsContainer = CameraButtonsContainer()
    let mediaButtonsContainer = MediaButtonsContainer()
    let previewImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, userInteraction: true)
    var videoPlayer: VideoPlayer = VideoPlayer(frame: .zero)
    let previewView = UIView()
    var imagePicker: ImagePicker!

    //AV Components
    let previewLayer = AVCaptureVideoPreviewLayer()
    let captureSession = AVCaptureSession()
    let output = AVCapturePhotoOutput()
    let movieOutput = AVCaptureMovieFileOutput()
    var videoDevice: AVCaptureDevice?
    //Logic helpers
    var frontCam = false
    var torchOn = false
    var videoUrl: URL?
    var videoTimer: Timer?
    var videoCounter = 0 {
        didSet {
            if videoCounter >= 10 {
                if movieOutput.isRecording {
                    movieOutput.stopRecording()
                    toggleTorchAfterCapturing()
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        cameraButtonsContainer.delegate = self
        mediaButtonsContainer.delegate = self
        setupUI()
        setupCaptureSession()
        setupGestureRecognizers()
    }
    
    func toggleTorchAfterCapturing() {
        if torchOn {
            handleToggleFlash()
        }
    }
    fileprivate func setupGestureRecognizers() {
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapToFocus(tap:)))
        previewView.addGestureRecognizer(tapGesture)
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissView))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
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
        self.videoUrl = url
        videoPlayer.play()
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
    
    func showTapFocusIndicator(point: CGPoint) {
        if tapImage.superview != nil {
            tapImage.removeFromSuperview()
        }
        tapImage.frame = CGRect(x: point.x, y: point.y, width: 55, height: 55)
        self.tapImage.alpha = 1
        UIView.animate(withDuration: 0.5, animations: {
            self.previewView.addSubview(self.tapImage)
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.tapImage.alpha = 0
            }) { (_) in
                self.tapImage.removeFromSuperview()
            }
        }
    }
    let customAnimationPresenter = CameraAnimationPresenter()
    let customAnimationDismisser = CameraAnimationDismisser()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresenter
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
}

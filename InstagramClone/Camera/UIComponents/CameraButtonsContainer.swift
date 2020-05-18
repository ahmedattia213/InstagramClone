//
//  CameraButtonsContainer.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/16/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit

protocol CameraContainerProtocol: class {
    func handleCapturePhoto()
    func handleHoldCaptureButton()
    func handleDismissView()
    func handleSwitchCamera()
    func handleToggleFlash()
    func handleAddMedia()
}
class CameraButtonsContainer: UIView {

    weak var delegate: CameraContainerProtocol?

    lazy var capturePhotoButton: UIButton = {
        let button = UIButton.systemButton( image: UIImage(named: "capture_photo"), target: self, selector: #selector(handleCapturePhoto))
        button.addTarget(self, action: #selector(holdDownButton), for: .touchDown)
        return button
    }()

    lazy var dismissViewButton = UIButton.systemButton( image: UIImage(named: "cancel_shadow"), target: self, selector: #selector(handleDismissView))

    lazy var switchCamButton = UIButton.systemButton( image: UIImage(named: "flip_camera"), target: self, selector: #selector(handleSwitchCamera))

    lazy var toggleFlashButton = UIButton.systemButton( image: UIImage(named: "flash_off"), target: self, selector: #selector(handleToggleFlash))
    
    lazy var addMediaButton = UIButton.systemButton( image: UIImage(named: "add_media"), target: self, selector: #selector(handleAddMedia))
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviews(capturePhotoButton, dismissViewButton, switchCamButton, toggleFlashButton, addMediaButton)
        switchCamButton.tintColor = .white
        dismissViewButton.tintColor = .white
        addMediaButton.tintColor = .white
        capturePhotoButton.anchor(bottom: bottomAnchor, bottomConstant: 12, widthConstant: 80, heightConstant: 80, centerXInSuperView: true )
        dismissViewButton.anchor(topAnchor, right: rightAnchor, topConstant: 12, rightConstant: 12, widthConstant: 50, heightConstant: 50)
        switchCamButton.anchor(bottom: bottomAnchor, right: rightAnchor, bottomConstant: 0, rightConstant: 12, widthConstant: 60, heightConstant: 60)
        toggleFlashButton.anchor(dismissViewButton.bottomAnchor, right: rightAnchor, topConstant: 10, rightConstant: 12, widthConstant: 50, heightConstant: 50)
        addMediaButton.anchor(left: leftAnchor, bottom: bottomAnchor, leftConstant: 12, bottomConstant: 0, widthConstant: 60, heightConstant: 60)

    }

    @objc private func handleCapturePhoto() {
        delegate?.handleCapturePhoto()
    }
    @objc private func holdDownButton() {
        delegate?.handleHoldCaptureButton()
    }

    @objc private func handleDismissView() {
        delegate?.handleDismissView()
    }

    @objc private func handleSwitchCamera() {
        delegate?.handleSwitchCamera()
    }
    
    @objc private func handleToggleFlash() {
        delegate?.handleToggleFlash()
    }
    
    @objc private func handleAddMedia() {
        delegate?.handleAddMedia()
    }
}

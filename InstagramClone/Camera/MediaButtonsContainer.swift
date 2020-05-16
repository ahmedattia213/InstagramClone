//
//  MediaButtonsContainer.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/16/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit
protocol MediaContainerProtocol: class {
    func handleDismissMedia()
    func handleSaveMedia()
}
class MediaButtonsContainer: UIView {
    weak var delegate: MediaContainerProtocol?

    lazy var dismissMediaButton = UIButton.systemButton( image: UIImage(named: "cancel_shadow"), target: self, selector: #selector(handleDismissMedia))

    lazy var saveMediaButton = UIButton.systemButton( image: UIImage(named: "save_image"), target: self, selector: #selector(handleSaveMedia))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviews(dismissMediaButton, saveMediaButton)
        dismissMediaButton.tintColor = .white
        saveMediaButton.tintColor = .white
        dismissMediaButton.anchor(topAnchor, left: leftAnchor, topConstant: 12, leftConstant: 12, widthConstant: 50, heightConstant: 50)
        saveMediaButton.anchor(topAnchor, topConstant: 12, widthConstant: 50, heightConstant: 50, centerXInSuperView: true )
    }

    @objc private func handleDismissMedia() {
        delegate?.handleDismissMedia()
    }

    @objc private func handleSaveMedia() {
        delegate?.handleSaveMedia()
    }
}

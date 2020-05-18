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

    lazy var savedLabel: UILabel = {
        let label = UILabel(text: "Saved", font: UIFont.boldSystemFont(ofSize: 16), color: UIColor.white, textAlignment: .center, numberOfLines: 0)
        label.backgroundColor = UIColor(hex: 0x000000, alpha: 0.4)
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.center = self.center
        return label
    }()
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

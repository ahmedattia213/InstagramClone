//
//  SharePhotoController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 8/24/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController, UITextViewDelegate {

    let containerView = UIView()
    lazy var imageShared: UIImageView = {
        let image = UIImageView(image: nil, contentMode: .scaleAspectFit, cornerRadius: 2, userInteraction: true)
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(performZoomInForStartingImageView)))
        return image
    }()

    lazy var captionTextView: UITextView = {
        let textView = UITextView(text: "Write a caption...", font: .systemFont(ofSize: 14), color: .lightGray)
        textView.delegate = self
        return textView
    }()

    let navBarSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    let containerSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    //zoomIn Functionality variables
    var startingImageView: UIImageView = UIImageView(image: nil, contentMode: .scaleAspectFit, cornerRadius: 2, userInteraction: true)
    var startingFrame = CGRect()
    var zoomedImageBackground = UIView()
    let zoomingImageView = UIImageView(image: nil, contentMode: .scaleAspectFit, userInteraction: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupContainerView()
    }

    private func setupContainerView() {
        let top = view.safeAreaLayoutGuide.topAnchor
        containerView.addSubviews(imageShared, captionTextView)
        view.addSubviews(navBarSeparator, containerView, containerSeparator)

        navBarSeparator.anchor(top, left: view.leftAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, heightConstant: 0.75)
        containerView.anchor(navBarSeparator.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, heightConstant: 100)
        imageShared.anchor(left: containerView.leftAnchor, leftConstant: 15, widthConstant: 75, heightConstant: 75, centerYInSuperView: true)
        captionTextView.anchor(containerView.topAnchor, left: imageShared.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor,
                                topConstant: 15, leftConstant: 15, bottomConstant: 15, rightConstant: 15)

        containerSeparator.anchor(containerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, heightConstant: 0.5)
    }
    private func setupNavBar() {
        navigationItem.title = "New Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UILabel(text: "share", font: .systemFont(ofSize: 17), color: .blue))
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleShare() {
        print("SHARE")
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if  textView.text == "Write a caption..." && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 14)
        }
        textView.becomeFirstResponder()
    }

    @objc func performZoomInForStartingImageView() {
        print(imageShared.frame)
        let navbarHeight = self.navigationController?.navigationBar.frame.size.height
        startingFrame = imageShared.frame
        startingFrame.origin.y += navbarHeight ?? 0
        self.startingImageView = imageShared
        self.startingImageView.isHidden = true
        zoomingImageView.frame = startingFrame
        zoomingImageView.image = imageShared.image
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePictureaAndBackground)))
        if let keyWindow = UIApplication.shared.keyWindow {
            zoomedImageBackground = UIView(frame: keyWindow.frame)
            zoomedImageBackground.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 0.7)
            zoomedImageBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePictureaAndBackground)))
            keyWindow.addSubview(zoomedImageBackground)
            keyWindow.addSubview(zoomingImageView)
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.zoomedImageBackground.alpha = 1
                let height = keyWindow.frame.width * (self.startingFrame.height / self.startingFrame.width)
                self.zoomingImageView.frame =  CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                self.zoomingImageView.center = keyWindow.center
            }, completion: nil)
        }
    }

    @objc func removePictureaAndBackground(tapGesture: UITapGestureRecognizer ) {
        let zoomingOutImageView = zoomingImageView
            zoomingOutImageView.clipsToBounds = true
            zoomingOutImageView.layer.cornerRadius = 2
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomingOutImageView.frame = self.startingFrame
                self.zoomedImageBackground.alpha = 0
            }) { (_) in
                self.startingImageView.isHidden = false
                zoomingOutImageView.removeFromSuperview()
            }
    }
}

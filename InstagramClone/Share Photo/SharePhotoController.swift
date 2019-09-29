//
//  SharePhotoController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 8/24/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController, UITextViewDelegate {

    let containerView = UIView()
    var selectedImage: UIImage? {
        didSet {
            self.imageShared.image = selectedImage!
        }
    }
    lazy var imageShared: UIImageView = {
        let image = UIImageView(image: nil, contentMode: .scaleAspectFit, cornerRadius: 2, userInteraction: true)
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(performZoomInForStartingImageView)))
        return image
    }()

    lazy var captionTextView: UITextView = {
        let textView = UITextView(text: .captionPlaceholder, font: .systemFont(ofSize: 14), color: .lightGray)
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

    lazy var shareButton = UIButton.systemButton(title: "share", titleColor: .blue, font: .systemFont(ofSize: 17), target: self, selector: #selector(handleShare))

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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleShare() {
        guard let image = selectedImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let fileName = UUID().uuidString
        let postsRef = FirebaseHelper.userPostsStorage.child(fileName)
        self.shareButton.isEnabled = false
        postsRef.putData(imageData, metadata: nil) { (_, err) in
            if err != nil {
                self.shareButton.isEnabled = true
                print("Failed to Upload Post ", err!)
                return
            }
            postsRef.downloadURL(completion: { (imgUrl, err) in
                if err != nil {
                    self.shareButton.isEnabled = true
                    print("Failed to Download Url for Post ", err!)
                    return
                }
                guard let imgUrlString = imgUrl?.absoluteString else { return }
                self.savePostToDatabase(imageUrl: imgUrlString)
            })
        }
    }

    private func savePostToDatabase(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard var caption = captionTextView.text else { return }
        if caption == .captionPlaceholder {
            caption = ""
        }
        let values = ["postUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String: Any]
        let usersPostsRef = FirebaseHelper.userPostsDatabase.child(uid).childByAutoId()
        usersPostsRef.updateChildValues(values) { (err, _) in
            if err != nil {
                self.shareButton.isEnabled = true
                print("Failed to save Post to Database", err!)
                return
            }
                print("Successfully Saved Post To Database")
            self.dismiss(animated: true, completion: nil)
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if  textView.text == .captionPlaceholder && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 14)
        }
        textView.becomeFirstResponder()
    }

    @objc func performZoomInForStartingImageView() {
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
            }) { _ in
                self.startingImageView.isHidden = false
                zoomingOutImageView.removeFromSuperview()
            }
    }
}

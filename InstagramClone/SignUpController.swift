//
//  SignUpController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 7/28/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    var imagePicker: ImagePickerHelper!
    let plusPhotoButton = UIButton.systemButton(image: UIImage(named: "plus_photo"), target: self, selector: #selector(handlePhotoButton))
    
    let emailTextfield: UITextField = {
        let tf = UITextField(placeholder: "Email", font: .signupTextfield, backgroundColor: .signupTextfield, borderStyle: .roundedRect)
        tf.addTarget(self, action: #selector(handleTextInputEditing), for: .editingChanged)
        return tf
    }()
    
    let usernameTextfield: UITextField = {
        let tf = UITextField(placeholder: "Username", font: .signupTextfield, backgroundColor: .signupTextfield, borderStyle: .roundedRect)
        tf.addTarget(self, action: #selector(handleTextInputEditing), for: .editingChanged)
        return tf
    }()
    
    let passwordTextfield: UITextField = {
        let tf = UITextField(placeholder: "Password", font: .signupTextfield, backgroundColor: .signupTextfield, borderStyle: .roundedRect)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextInputEditing), for: .editingChanged)
        return tf
    }()
    
    let signupButton : UIButton = {
        let button = UIButton.systemButton(title: "Sign Up", titleColor: .white, backgroundColor: .dimmedSignupButton, font: .signupButton, target: self, selector: #selector(handleSignup))
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()
    lazy var textfieldStackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fillEqually, spacing: 10, arrangedSubviews: [emailTextfield,usernameTextfield,
                                                                                                                    passwordTextfield,signupButton])
    
     let signInButton = UIButton.systemButton(title: "Already have an account? Sign In", titleColor: .lightGray, font: UIFont.systemFont(ofSize: 13), target: self, selector: #selector(handleShowSignIn))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    @objc func handleShowSignIn() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        view.addSubviews(plusPhotoButton,textfieldStackView,signInButton)
        plusPhotoButton.anchor(view.topAnchor, topConstant: 40, widthConstant: 140, heightConstant: 140, centerXInSuperView: true)
        textfieldStackView.anchor(plusPhotoButton.bottomAnchor, topConstant: 20, heightConstant: 190, centerXInSuperView: true)
        textfieldStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        signInButton.anchor(bottom: view.bottomAnchor, bottomConstant: 6, centerXInSuperView: true)
        setupSignInButtonText()
    }
    
    private func setupSignInButtonText() {
        let signInButtonText = NSMutableAttributedString(string: "Already have an account? ", attributes: nil)
        signInButtonText.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.foregroundColor: UIColor.signupButton]))
        signInButton.setAttributedTitle(signInButtonText, for: .normal)
    }
    
    @objc func handlePhotoButton() {
        print("hello")
        imagePicker = ImagePickerHelper(presentedViewController: self, delegate: self)
        imagePicker.present(from: self.view)
    }
    
    @objc func handleSignup() {
        guard let email = emailTextfield.text, email.count > 0 else { return }
        guard let username = usernameTextfield.text, username.count > 0 else { return }
        guard let password = passwordTextfield.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("failed to create user: ",err)
                return
            }
            print("Successfully created a user")
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            let fileName = UUID().uuidString
            let storageRef = FirebaseHelper.profileImages.child(fileName)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Failed to save profile images to storage:", err)
                    return
                }
                storageRef.downloadURL(completion: { (downloadUrl, err) in
                    if let err = err {
                        print("Failed to fetch downloadURL:", err)
                        return
                    }
                    print("Successfully uploaded image: ",downloadUrl?.absoluteString as Any)
                    guard let profileImageUrl = downloadUrl?.absoluteString else { return }
                    guard let uid = user?.user.uid else { return }
                    let dictionaryValues = [ "username": username, "profileImageUrl": profileImageUrl]
                    let values =  [ uid : dictionaryValues ]
                    
                    FirebaseHelper.usersDatabase.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print("Failed to update users database: ",err)
                            return
                        }
                        print("Successfully saved user's username to our db")
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        mainTabBarController.setupViewControllers()
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
    }
    
    @objc func handleTextInputEditing() {
        let isFormValid = ValidationsHelper.isValidEmail(emailTextfield.text ?? "") && ValidationsHelper.isValidPassword(passwordTextfield.text ?? "") && ValidationsHelper.isValidUsername(usernameTextfield.text ?? "")
        
        if isFormValid {
            signupButton.backgroundColor = .signupButton
            signupButton.isEnabled = true
        } else {
            signupButton.backgroundColor = .dimmedSignupButton
            signupButton.isEnabled = false
        }
    }
}


extension SignUpController: ImagePickerDelegate {
    func didSelect(selectedMedia: Any?) {
        plusPhotoButton.setImage((selectedMedia as? UIImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.roundCircular(width: plusPhotoButton.frame.width)
        plusPhotoButton.layer.borderColor = (UIColor.black).cgColor
        plusPhotoButton.layer.borderWidth = 2
    }
    
    
}

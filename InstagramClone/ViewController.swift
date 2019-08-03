//
//  ViewController.swift
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
        let textField = UITextField(placeholder: "Email", font: .signupTextfield, backgroundColor: .signupTextfield, borderStyle: .roundedRect)
        textField.addTarget(self, action: #selector(handleTextInputEditing), for: .editingChanged)
        return textField
    }()

    let usernameTextfield: UITextField = {
        let textField = UITextField(placeholder: "Username", font: .signupTextfield, backgroundColor: .signupTextfield, borderStyle: .roundedRect)
        textField.addTarget(self, action: #selector(handleTextInputEditing), for: .editingChanged)
        return textField
    }()

    let passwordTextfield: UITextField = {
        let textField = UITextField(placeholder: "Password", font: .signupTextfield, backgroundColor: .signupTextfield, borderStyle: .roundedRect)
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextInputEditing), for: .editingChanged)
        return textField
    }()

    let signupButton: UIButton = {
        let button = UIButton.systemButton(title: "Sign Up", titleColor: .white, backgroundColor: .dimmedSignupButton, font: .signupButton, target: self, selector: #selector(handleSignup))
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()
    lazy var textfieldStackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fillEqually, spacing: 10, arrangedSubviews: [emailTextfield, usernameTextfield, passwordTextfield, signupButton])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.addSubviews(plusPhotoButton, textfieldStackView)
        plusPhotoButton.anchor(view.topAnchor, topConstant: 40, widthConstant: 140, heightConstant: 140, centerXInSuperView: true)
        textfieldStackView.anchor(plusPhotoButton.bottomAnchor, topConstant: 20, heightConstant: 190, centerXInSuperView: true)
        textfieldStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
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
                print("failed to create user: ", err)
                return
            }
            print("Successfully created a user")

            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            let fileName = UUID().uuidString
            let storageRef = FirebaseHelper.profileImages.child(fileName)
            storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                if let err = err {
                    print("Failed to save profile images to storage:", err)
                    return
                }
                storageRef.downloadURL(completion: { (downloadUrl, err) in
                    if let err = err {
                        print("Failed to fetch downloadURL:", err)
                        return
                    }
                    print("Successfully uploaded image: ", downloadUrl?.absoluteString as Any)
                    guard let profileImageUrl = downloadUrl?.absoluteString else { return }
                    guard let uid = user?.user.uid else { return }
                    let dictionaryValues = [ "username": username, "profileImageUrl": profileImageUrl]
                    let values =  [ uid: dictionaryValues ]
                    updateUsersDatabase(values: values)
                })
            })
        }
    }

    private func updateUsersDatabase(values: [String: Any]) {
        FirebaseHelper.usersDatabase.updateChildValues(values, withCompletionBlock: { (err, _) in
            if let err = err {
                print("Failed to update users database: ", err)
                return
            }
            print("Successfully saved user's username to our db")
        })
    }

    @objc func handleTextInputEditing() {
        let isFormValid = isValidEmail(email: emailTextfield.text ?? "") && isValidPassword(password: passwordTextfield.text ?? "") && isValidUsername(username: usernameTextfield.text ?? "")

        if isFormValid {
            signupButton.backgroundColor = .signupButton
            signupButton.isEnabled = true
        } else {
            signupButton.backgroundColor = .dimmedSignupButton
            signupButton.isEnabled = false
        }
    }

    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func isValidPassword(password: String) -> Bool {
        return password.count > 5
    }

    func isValidUsername(username: String) -> Bool {
        return username.count > 2
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

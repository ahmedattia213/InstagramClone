//
//  ViewController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 7/28/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.addSubviews(plusPhotoButton,textfieldStackView)
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
                print("failed to create user: ",err)
                return
            }
            print("Successfully created a user")
            
            guard let uid = user?.user.uid else { return }
            let usernameValue = [ "username": username ]
            let values =  [ uid : usernameValue ]
            
            FirebaseHelper.usersDatabase.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to update users database: ",err)
                    return
                }
                print("Successfully saved user's username to our db")
            })
            
        }
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
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        return password.count > 5
    }
    
    func isValidUsername(username: String) -> Bool {
        return username.count > 2
    }

}


extension ViewController: ImagePickerDelegate {
    func didSelect(selectedMedia: Any?) {
        plusPhotoButton.setImage((selectedMedia as? UIImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    
}

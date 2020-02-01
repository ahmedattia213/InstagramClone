//
//  LoginController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 7/31/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    let signUpButton = UIButton.systemButton(title: "Don't have an account? Sign Up", titleColor: .lightGray, font: UIFont.systemFont(ofSize: 13), target: self, selector: #selector(handleShowSignUp))

    let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .logoBackground
        let logo = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"), contentMode: .scaleAspectFill)
        view.addSubview(logo)
        logo.anchor(widthConstant: 200, heightConstant: 60, centerXInSuperView: true, centerYInSuperView: true)
        return view
    }()

    let emailTextfield: UITextField = {
        let textField = UITextField(placeholder: "Email", font: .signupTextfield, backgroundColor: .signupTextfield, borderStyle: .roundedRect)
        textField.addTarget(self, action: #selector(handleTextInputEditing), for: .editingChanged)
        return textField
    }()

    let passwordTextfield: UITextField = {
        let textField = UITextField(placeholder: "Password", font: .signupTextfield, backgroundColor: .signupTextfield, borderStyle: .roundedRect)
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextInputEditing), for: .editingChanged)
        return textField
    }()

    let signInButton: UIButton = {
        let button = UIButton.systemButton(title: "Sign In", titleColor: .white, backgroundColor: .dimmedSignupButton, font: .signupButton, target: self, selector: #selector(handleSignin))
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()

    lazy var signInStackView = UIStackView(axis: .vertical, distribution: .fillEqually, spacing: 10, arrangedSubviews: [emailTextfield, passwordTextfield, signInButton])

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubviews(signUpButton, logoContainerView, signInStackView)
        setupSignUpButton()
        setupLogoContainerView()
        setupSignInStackView()
    }

    func setupSignUpButton() {
        let bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        let signUpButtonText = NSMutableAttributedString(string: "Don't have an account?", attributes: nil)
        signUpButtonText.append(NSAttributedString(string: " Sign Up", attributes: [NSAttributedString.Key.foregroundColor: UIColor.signupButton]))
        signUpButton.setAttributedTitle(signUpButtonText, for: .normal)
        signUpButton.anchor(bottom: bottomAnchor, bottomConstant: 5, centerXInSuperView: true)
    }

    func setupLogoContainerView() {
        logoContainerView.anchor(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, heightConstant: 180)
    }

    func setupSignInStackView() {
        signInStackView.anchor(logoContainerView.bottomAnchor, topConstant: 20, heightConstant: 140, centerXInSuperView: true)
        signInStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
    @objc func handleShowSignUp() {
        navigationController?.pushViewController(SignUpController(), animated: true)
    }

    @objc func handleTextInputEditing() {
        let isFormValid = ValidationsHelper.isValidEmail(emailTextfield.text ?? "") && ValidationsHelper.isValidPassword(passwordTextfield.text ?? "")
        if isFormValid {
            signInButton.backgroundColor = .signupButton
            signInButton.isEnabled = true
        } else {
            signInButton.backgroundColor = .dimmedSignupButton
            signInButton.isEnabled = false
        }
    }

    @objc func handleSignin() {
        guard let email = emailTextfield.text, ValidationsHelper.isValidEmail(email) == true else { return }
        guard let password = passwordTextfield.text, ValidationsHelper.isValidPassword(password) else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (_, err) in
            if let err = err {
                print("Failed to log in: ", err)
                return
            }
          //  self.present(MainTabBarController(), animated: true, completion: nil)
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

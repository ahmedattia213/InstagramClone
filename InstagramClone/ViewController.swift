//
//  ViewController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 7/28/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let plusPhotoButton = UIButton.systemButton(image: UIImage(named: "plus_photo"), target: self, selector: #selector(handlePhotoButton))

    let emailTextfield = UITextField(placeholder: "Email", font: UIFont.systemFont(ofSize: 14), backgroundColor: UIColor(white: 0, alpha: 0.03), borderStyle: .roundedRect)
    let usernameTextfield = UITextField(placeholder: "Username", font: UIFont.systemFont(ofSize: 14), backgroundColor: UIColor(white: 0, alpha: 0.03), borderStyle: .roundedRect)
    let passwordTextfield: UITextField = {
        let tf = UITextField(placeholder: "Password", font: UIFont.systemFont(ofSize: 14), backgroundColor: UIColor(white: 0, alpha: 0.03), borderStyle: .roundedRect)
        tf.isSecureTextEntry = true
        return tf
    }()
    let signupButton : UIButton = {
        let button = UIButton.systemButton(title: "Sign Up", titleColor: .white, backgroundColor: UIColor(hex: 0x95ccf4), font: UIFont.systemFont(ofSize: 14), target: self, selector: #selector(handleSignup))
        button.layer.cornerRadius = 5
        return button
    }()
    lazy var textfieldStackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fillEqually, spacing: 10, arrangedSubviews: [emailTextfield,usernameTextfield,
                                         passwordTextfield,signupButton])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    func setupUI() {
        view.addSubviews(plusPhotoButton,textfieldStackView)
        passwordTextfield.isSecureTextEntry = true
        plusPhotoButton.anchor(view.topAnchor, topConstant: 40, widthConstant: 140, heightConstant: 140, centerXInSuperView: true)
        textfieldStackView.anchor(plusPhotoButton.bottomAnchor, topConstant: 20, heightConstant: 190, centerXInSuperView: true)
        textfieldStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
    @objc func handlePhotoButton() {
        print("hello")
    }
    @objc func handleSignup() {
        print("signup")
    }

}


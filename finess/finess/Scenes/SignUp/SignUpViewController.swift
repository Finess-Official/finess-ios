//
//  ViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 27.03.2025.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - Private Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = button.state == .normal ? UIColor(named: "ActiveButton"): UIColor(named: "DisabledButton")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 26
        return button
    }()

    private let passwordTextField = RegisterTextField(placeholder: "Пароль")

    private let repeatPasswordTextField = RegisterTextField(placeholder: "Повторите пароль")

    private var buttonBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            buttonBottomConstraint = signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18 - keyboardSize.height)
            buttonBottomConstraint.isActive = true
            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        buttonBottomConstraint = signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18)
        buttonBottomConstraint.isActive = true
        view.layoutIfNeeded()
    }

    private func setupUI() {
        view.backgroundColor = .white

        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        repeatPasswordTextField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(repeatPasswordTextField)
        view.addSubview(signupButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            passwordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56),

            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 36),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 56),

            signupButton.heightAnchor.constraint(equalToConstant: 48),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])

        buttonBottomConstraint = signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18)
        buttonBottomConstraint.isActive = true
    }

    // MARK: - Actions
    @objc func tapGesture() {
        passwordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tapGesture()
        return true
    }
}

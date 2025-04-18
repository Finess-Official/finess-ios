//
//  SignInViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import UIKit

protocol SignInViewControllerDelegate: AnyObject {
    func didTapSignInButton(with password: String?)
    func didTapSignUpButton()
}

class SignInViewController: UIViewController {

    // MARK: - Public Properties
    weak var delegate: SignInViewControllerDelegate?

    // MARK: - Private Properties
    private let passwordTextFieldErrorLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.password
        label.font = Constants.errorFont
        label.textAlignment = Constants.textAlignment
        label.textColor = Constants.errorColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.signIn
        label.font = Constants.titleFont
        label.textAlignment = Constants.textAlignment
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var signinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.signinButton, for: .normal)
        button.titleLabel?.font = Constants.largeButtonFont
        button.setTitleColor(Constants.buttonTitleColor, for: .normal)
        button.backgroundColor = Constants.disabledButtonColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            delegate?.didTapSignInButton(with: passwordTextField.text)
        }), for: .touchUpInside)
        return button
    }()

    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.createAccount, for: .normal)
        button.titleLabel?.font = Constants.middleButtonFont
        button.setTitleColor(Constants.activeButtonColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            delegate?.didTapSignUpButton()
        }), for: .touchUpInside)
        return button
    }()

    private let passwordTextField = RegisterTextField(placeholder: Constants.password)

    private var signupButtonTopConstraint: NSLayoutConstraint?

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor

        passwordTextField.delegate = self

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(signinButton)
        view.addSubview(signupButton)
        view.addSubview(passwordTextFieldErrorLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),

            passwordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            passwordTextFieldErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Constants.errorLabelTopPadding),
            passwordTextFieldErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.errorLabelLeadingPadding),

            signinButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            signinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            signinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),

            signupButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),

            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: signinButton.bottomAnchor, constant: Constants.horizontalPadding)
        ])

        updateSignupButtonConstraint()
    }

    private func updateSignupButtonConstraint() {
        if let existingConstraint = signupButtonTopConstraint {
            NSLayoutConstraint.deactivate([existingConstraint])
        }

        let newConstraint: NSLayoutConstraint
        if passwordTextFieldErrorLabel.isHidden {
            newConstraint = signupButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4)
        } else {
            newConstraint = signupButton.topAnchor.constraint(equalTo: passwordTextFieldErrorLabel.bottomAnchor, constant: 4)
        }

        NSLayoutConstraint.activate([newConstraint])
        signupButtonTopConstraint = newConstraint
    }

    private func changeButtonState(isEnabled: Bool) {
        signinButton.isEnabled = isEnabled
        signinButton.backgroundColor = isEnabled ? Constants.activeButtonColor: Constants.disabledButtonColor
    }

    // MARK: - Actions
    @objc func tapGesture() {
        passwordTextField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tapGesture()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if passwordTextField.text?.isEmpty ?? true {
            changeButtonState(isEnabled: false)
        } else {
            changeButtonState(isEnabled: true)
        }

        if let count = passwordTextField.text?.count, count < Constants.minSymbolCount {
            changeButtonState(isEnabled: false)
            passwordTextField.isInErrorState = true
            passwordTextFieldErrorLabel.isHidden = false
        } else {
            changeButtonState(isEnabled: true)
            passwordTextField.isInErrorState = false
            passwordTextFieldErrorLabel.isHidden = true
        }

        if let count = passwordTextField.text?.count, count == Constants.maxSymbolCount + 1, textField == passwordTextField {
            let text = passwordTextField.text ?? ""
            passwordTextField.text = String(text.dropLast())
        }

        updateSignupButtonConstraint()
    }
}


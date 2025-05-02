//
//  SignInViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import UIKit

protocol SignInViewControllerDelegate: AnyObject {
    func didTapSignUpButton()
}

class SignInViewController: UIViewController {

    // MARK: - Internal Properties
    weak var delegate: SignInViewControllerDelegate?

    // MARK: - Private Properties
    private let loadingViewController = LoadingViewController()
    
    private let passwordTextFieldErrorLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("lessThanSixSymbols", comment: "")
        label.font = Constants.errorFont
        label.textAlignment = Constants.textAlignment
        label.textColor = Constants.errorColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("signIn", comment: "")
        label.font = Constants.titleFont
        label.textAlignment = Constants.textAlignment
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var signinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("signInAction", comment: ""), for: .normal)
        button.titleLabel?.font = Constants.largeButtonFont
        button.setTitleColor(Constants.buttonTitleColor, for: .normal)
        button.backgroundColor = Constants.disabledButtonColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            loadingViewController.start()
            didTapSignInButton(with: passwordTextField.text)
            passwordTextField.text = ""
        }), for: .touchUpInside)
        return button
    }()

    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("createAccount", comment: ""), for: .normal)
        button.titleLabel?.font = Constants.middleButtonFont
        button.setTitleColor(Constants.activeButtonColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            delegate?.didTapSignUpButton()
        }), for: .touchUpInside)
        return button
    }()

    private let passwordTextField = RegisterTextField(placeholder: NSLocalizedString("password", comment: ""), mode: .secure)

    private var signupButtonTopConstraint: NSLayoutConstraint?

    // MARK: - Initializer
    init(userDidSignedUp: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.signupButton.isHidden = userDidSignedUp
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordTextField.text = ""
        passwordTextFieldErrorLabel.isHidden = true
        passwordTextField.isInErrorState = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = Constants.authBackgroundColor

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

            passwordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.mediumSpacing),
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

    private func didTapSignInButton(with password: String?) {
        guard let password = password else { return }
        navigationController?.pushViewController(loadingViewController, animated: false)
        Auth.shared.signIn(password: password) { [weak self] error in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: false) {
                    if let error = error {
                        ErrorHandler.shared.showError(error, navigationController: self?.navigationController)
                    }
                }
            }
        }
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


//
//  ViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 27.03.2025.
//

import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
    func didTapSignIn()
}

class SignUpViewController: UIViewController {

    // MARK: - Internal Properties
    weak var delegate: SignUpViewControllerDelegate?

    // MARK: - Private Properties
    private let loadingView = LoadingView()
    
    private let passwordTextFieldErrorLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("lessThanSixSymbols", comment: "")
        label.font = Constants.errorFont
        label.textAlignment = Constants.textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.errorColor
        return label
    }()

    private let repeatPasswordTextFieldErrorLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("repeatPassword", comment: "")
        label.font = Constants.errorFont
        label.textAlignment = Constants.textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.errorColor
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("signUp", comment: "")
        label.font = Constants.titleFont
        label.textAlignment = Constants.textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.textColor
        return label
    }()

    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("signUpAction", comment: ""), for: .normal)
        button.titleLabel?.font = Constants.largeButtonFont
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.backgroundColor = Constants.disabledButtonColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if let count = repeatPasswordTextField.text?.count, count != 0 {
                if passwordTextField.text != repeatPasswordTextField.text {
                    repeatPasswordTextField.isInErrorState = true
                    view.addSubview(repeatPasswordTextFieldErrorLabel)
                    repeatPasswordTextFieldErrorLabel.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 4).isActive = true
                    repeatPasswordTextFieldErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.textFieldLeftPadding + Constants.horizontalPadding  ).isActive = true
                } else {
                    repeatPasswordTextField.isInErrorState = false
                    repeatPasswordTextFieldErrorLabel.removeFromSuperview()
                    loadingView.start()
                    didTapSignUp(password: repeatPasswordTextField.text)
                }
            }
        }), for: .touchUpInside)
        return button
    }()

    private lazy var signinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("haveAccountSignIn", comment: ""), for: .normal)
        button.titleLabel?.font = Constants.middleButtonFont
        button.setTitleColor(Constants.activeButtonColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            delegate?.didTapSignIn()
        }), for: .touchUpInside)
        return button
    }()

    private let passwordTextField = RegisterTextField(placeholder: NSLocalizedString("password", comment: ""), mode: .secure)
    private let repeatPasswordTextField = RegisterTextField(placeholder: NSLocalizedString("repeatPassword", comment: ""), mode: .secure)
    private let loggingService = APILoggingService()

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
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
        cleanTextFields()
        passwordTextFieldErrorLabel.isHidden = true
        repeatPasswordTextFieldErrorLabel.isHidden = true
        passwordTextField.isInErrorState = false
        repeatPasswordTextField.isInErrorState = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
    }

    // MARK: - Private Methods
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
        view.addSubview(signinButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),

            passwordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.mediumSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Constants.mediumSpacing),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            signinButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor),
            signinButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            signinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            signinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),

            signupButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),

            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: Constants.horizontalPadding)
        ])
    }

    private func changeButtonState(isEnabled: Bool) {
        signupButton.isEnabled = isEnabled
        signupButton.backgroundColor = isEnabled ? Constants.activeButtonColor: Constants.disabledButtonColor
    }

    private func cleanTextFields() {
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }

    // MARK: - Actions
    @objc func tapGesture() {
        passwordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
    }

    private func didTapSignUp(password: String?) {
        guard let password = password else { return }
        Auth.shared.signUp(password: password) { [weak self] error in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: false) { [weak self] in
                    guard let self else { return }
                    if let error = error {
                        self.showError(error, loggingService: self.loggingService)
                    }
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tapGesture()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if passwordTextField.text?.isEmpty ?? true || repeatPasswordTextField.text?.isEmpty ?? true {
            changeButtonState(isEnabled: false)
        } else {
            changeButtonState(isEnabled: true)
        }

        if let count = passwordTextField.text?.count, count < Constants.minSymbolCount {
            changeButtonState(isEnabled: false)
            passwordTextField.isInErrorState = true
            view.addSubview(passwordTextFieldErrorLabel)
            passwordTextFieldErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Constants.errorLabelTopPadding).isActive = true
            passwordTextFieldErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.errorLabelLeadingPadding).isActive = true
        } else {
            changeButtonState(isEnabled: true)
            passwordTextField.isInErrorState = false
            passwordTextFieldErrorLabel.removeFromSuperview()
        }

        if let count = passwordTextField.text?.count, count == Constants.maxSymbolCount + 1, textField == passwordTextField {
            let text = passwordTextField.text ?? ""
            passwordTextField.text = String(text.dropLast())
        }
    }
}



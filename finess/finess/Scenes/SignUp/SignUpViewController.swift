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
    private var signinButtonTopConstraint: NSLayoutConstraint?
    private var signupButtonTopConstraint: NSLayoutConstraint?

    private let passwordTextFieldErrorLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("lessThanSixSymbols", comment: "")
        label.font = .tinkoffBody()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.errorColor
        return label
    }()

    private let repeatPasswordTextFieldErrorLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("repeatPassword", comment: "")
        label.font = .tinkoffBody()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.errorColor
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("signUp", comment: "")
        label.font = .tinkoffTitle1()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .tinkoffBlack
        return label
    }()

    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("signUpAction", comment: ""), for: .normal)
        button.titleLabel?.font = .tinkoffHeading()
        button.setTitleColor(.tinkoffBlack, for: .normal)
        button.backgroundColor = .tinkoffYellow
        button.layer.cornerRadius = 25
        button.isEnabled = false
        button.backgroundColor = .tinkoffYellow.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if let count = repeatPasswordTextField.text?.count, count != 0 {
                if passwordTextField.text != repeatPasswordTextField.text {
                    repeatPasswordTextField.isInErrorState = true
                    view.addSubview(repeatPasswordTextFieldErrorLabel)
                    repeatPasswordTextFieldErrorLabel.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 8).isActive = true
                    repeatPasswordTextFieldErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
                    repeatPasswordTextFieldErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
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
        button.titleLabel?.font = .tinkoffBody()
        button.backgroundColor = .clear
        button.setTitleColor(.tinkoffGray, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            delegate?.didTapSignIn()
        }), for: .touchUpInside)
        return button
    }()

    private let passwordTextField: RegisterTextField = {
        let textField = RegisterTextField(placeholder: NSLocalizedString("password", comment: ""), mode: .secure)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.tinkoffBlack.withAlphaComponent(0.1).cgColor
        textField.backgroundColor = .white
        return textField
    }()

    private let repeatPasswordTextField: RegisterTextField = {
        let textField = RegisterTextField(placeholder: NSLocalizedString("repeatPassword", comment: ""), mode: .secure)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.tinkoffBlack.withAlphaComponent(0.1).cgColor
        textField.backgroundColor = .white
        return textField
    }()

    private let firstNameTextField: RegisterTextField = {
        let textField = RegisterTextField(placeholder: NSLocalizedString("firstName", comment: ""), mode: .required)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.tinkoffBlack.withAlphaComponent(0.1).cgColor
        textField.backgroundColor = .white
        return textField
    }()

    private let lastNameTextField: RegisterTextField = {
        let textField = RegisterTextField(placeholder: NSLocalizedString("lastName", comment: ""), mode: .required)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.tinkoffBlack.withAlphaComponent(0.1).cgColor
        textField.backgroundColor = .white
        return textField
    }()

    private let middleNameTextField: RegisterTextField = {
        let textField = RegisterTextField(placeholder: NSLocalizedString("middleName", comment: ""), mode: .required)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.tinkoffBlack.withAlphaComponent(0.1).cgColor
        textField.backgroundColor = .white
        return textField
    }()

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

        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cleanTextFields()
        passwordTextFieldErrorLabel.isHidden = true
        repeatPasswordTextFieldErrorLabel.isHidden = true
        passwordTextField.isInErrorState = false
        repeatPasswordTextField.isInErrorState = false
        updateRepeatPasswordTextFieldConstraint()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstNameTextField.becomeFirstResponder()
        animateUIElements()
    }

    // MARK: - Private Methods
    private func animateUIElements() {
        // Animate title with bounce
        titleLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 0.6,
            delay: 0.3,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.2,
            options: [],
            animations: {
                self.titleLabel.transform = .identity
            }
        )

        // Fade in other elements
        let views = [firstNameTextField, lastNameTextField, middleNameTextField, passwordTextField, repeatPasswordTextField, signupButton, signinButton]
        views.forEach { $0.alpha = 0 }

        UIView.animate(
            withDuration: 0.4,
            delay: 0.6,
            options: [],
            animations: {
                views.forEach { $0.alpha = 1 }
            }
        )
    }

    private func setupUI() {
        view.backgroundColor = .tinkoffBackground

        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        middleNameTextField.delegate = self

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        repeatPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        middleNameTextField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(middleNameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(repeatPasswordTextField)
        view.addSubview(signupButton)
        view.addSubview(signinButton)
        view.addSubview(passwordTextFieldErrorLabel)
        view.addSubview(repeatPasswordTextFieldErrorLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            firstNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 50),

            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            lastNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lastNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 50),

            middleNameTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
            middleNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            middleNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            middleNameTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: middleNameTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextFieldErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            passwordTextFieldErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextFieldErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            repeatPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 50),

            repeatPasswordTextFieldErrorLabel.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 8),
            repeatPasswordTextFieldErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repeatPasswordTextFieldErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            signupButton.heightAnchor.constraint(equalToConstant: 50),
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            signinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 20)
        ])

        // Скрываем лейблы ошибок изначально
        passwordTextFieldErrorLabel.isHidden = true
        repeatPasswordTextFieldErrorLabel.isHidden = true

        updateSigninButtonConstraint()
        updateRepeatPasswordTextFieldConstraint()
    }

    private func updateSigninButtonConstraint() {
        if let existingConstraint = signinButtonTopConstraint {
            NSLayoutConstraint.deactivate([existingConstraint])
        }

        let newConstraint: NSLayoutConstraint
        if repeatPasswordTextFieldErrorLabel.isHidden {
            newConstraint = signinButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 16)
        } else {
            newConstraint = signinButton.topAnchor.constraint(equalTo: repeatPasswordTextFieldErrorLabel.bottomAnchor, constant: 16)
        }

        NSLayoutConstraint.activate([newConstraint])
        signinButtonTopConstraint = newConstraint
    }

    private func updateRepeatPasswordTextFieldConstraint() {
        if let existingConstraint = signupButtonTopConstraint {
            NSLayoutConstraint.deactivate([existingConstraint])
        }

        let newConstraint: NSLayoutConstraint
        if passwordTextFieldErrorLabel.isHidden {
            newConstraint = repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16)
        } else {
            newConstraint = repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextFieldErrorLabel.bottomAnchor, constant: 16)
        }

        NSLayoutConstraint.activate([newConstraint])
        signupButtonTopConstraint = newConstraint
    }

    private func changeButtonState(isEnabled: Bool) {
        signupButton.isEnabled = isEnabled
        signupButton.backgroundColor = isEnabled ? .tinkoffYellow : .tinkoffYellow.withAlphaComponent(0.5)
        signupButton.setTitleColor(isEnabled ? .tinkoffBlack : .tinkoffBlack.withAlphaComponent(0.5), for: .normal)
    }

    private func cleanTextFields() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        middleNameTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }

    // MARK: - Keyboard Notifications
    @objc private func keyboardWillShow(notification: NSNotification) {
        signinButton.isHidden = true
        signupButton.isHidden = true
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        signinButton.isHidden = false
        signupButton.isHidden = false
    }

    // MARK: - Actions
    @objc func tapGesture() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        middleNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
    }

    private func didTapSignUp(password: String?) {
        guard let password = password else { return }
        // Add button press animation
        UIView.animate(withDuration: 0.1, animations: {
            self.signupButton.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.signupButton.transform = .identity
            }
        }

        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let middleName = middleNameTextField.text ?? ""

        Auth.shared.signUp(firstName: firstName, lastName: lastName, middleName: middleName, password: password) { [weak self] error in
            DispatchQueue.main.async {
                guard let self else { return }
                if let error = error {
                    // Add shake animation for error
                    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
                    animation.timingFunction = CAMediaTimingFunction(name: .linear)
                    animation.duration = 0.6
                    animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -2.5, 2.5, 0.0]
                    self.repeatPasswordTextField.layer.add(animation, forKey: "shake")

                    self.showError(error, loggingService: self.loggingService)
                } else {
                    self.navigationController?.popViewController(animated: false)
                }
                self.loadingView.stop()
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            middleNameTextField.becomeFirstResponder()
        } else if textField == middleNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            repeatPasswordTextField.becomeFirstResponder()
        } else {
            tapGesture()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            if let count = passwordTextField.text?.count, count < Constants.minSymbolCount {
                passwordTextField.isInErrorState = true
                passwordTextFieldErrorLabel.isHidden = false
                updateRepeatPasswordTextFieldConstraint()
            }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            passwordTextField.isInErrorState = false
            passwordTextFieldErrorLabel.isHidden = true
            updateRepeatPasswordTextFieldConstraint()
        }
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if passwordTextField.text?.isEmpty ?? true || repeatPasswordTextField.text?.isEmpty ?? true ||
           firstNameTextField.text?.isEmpty ?? true || lastNameTextField.text?.isEmpty ?? true {
            changeButtonState(isEnabled: false)
        } else {
            changeButtonState(isEnabled: true)
        }

        if textField == passwordTextField {
            if let count = passwordTextField.text?.count, count < Constants.minSymbolCount {
                passwordTextField.isInErrorState = true
                passwordTextFieldErrorLabel.isHidden = false
            } else {
                passwordTextField.isInErrorState = false
                passwordTextFieldErrorLabel.isHidden = true
            }
        }

        // Check if passwords match when both fields are not empty
        if !(repeatPasswordTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true) {
            if passwordTextField.text != repeatPasswordTextField.text {
                changeButtonState(isEnabled: false)
                repeatPasswordTextField.isInErrorState = true
                repeatPasswordTextFieldErrorLabel.isHidden = false
            } else {
                repeatPasswordTextField.isInErrorState = false
                repeatPasswordTextFieldErrorLabel.isHidden = true
            }
        }

        if let count = passwordTextField.text?.count, count == Constants.maxSymbolCount + 1, textField == passwordTextField {
            let text = passwordTextField.text ?? ""
            passwordTextField.text = String(text.dropLast())
        }

        updateSigninButtonConstraint()
        updateRepeatPasswordTextFieldConstraint()
    }
}




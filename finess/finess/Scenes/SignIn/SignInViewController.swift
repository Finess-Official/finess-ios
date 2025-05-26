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
    private let loadingView = LoadingView()
    
    private let passwordTextFieldErrorLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("lessThanSixSymbols", comment: "")
        label.font = .tinkoffBody()
        label.textAlignment = .center
        label.textColor = Constants.errorColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("signIn", comment: "")
        label.font = .tinkoffTitle1()
        label.textAlignment = .center
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var signinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("signInAction", comment: ""), for: .normal)
        button.titleLabel?.font = .tinkoffHeading()
        button.setTitleColor(.tinkoffBlack, for: .normal)
        button.backgroundColor = .tinkoffYellow
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            loadingView.start()
            didTapSignInButton(with: passwordTextField.text)
            passwordTextField.text = ""
        }), for: .touchUpInside)
        return button
    }()

    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("createAccount", comment: ""), for: .normal)
        button.titleLabel?.font = .tinkoffBody()
        button.backgroundColor = .clear
        button.setTitleColor(.tinkoffGray, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            delegate?.didTapSignUpButton()
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

    private let loggingService = APILoggingService()
    private var signupButtonTopConstraint: NSLayoutConstraint?

    // MARK: - Initializer
    init(userDidSignedUp: Bool) {
        super.init(nibName: nil, bundle: nil)
//        self.signupButton.isHidden = userDidSignedUp
        self.signupButton.isHidden = false
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
        navigationController?.navigationBar.applyTinkoffStyle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
        animateUIElements()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .tinkoffBackground

        passwordTextField.delegate = self
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(signinButton)
        view.addSubview(signupButton)
        view.addSubview(passwordTextFieldErrorLabel)

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            passwordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextFieldErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            passwordTextFieldErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextFieldErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            signinButton.heightAnchor.constraint(equalToConstant: 50),
            signinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

//            signupButton.heightAnchor.constraint(equalToConstant: 44),
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: signinButton.bottomAnchor, constant: 20)
        ])

        updateSignupButtonConstraint()
    }

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
        let views = [passwordTextField, signinButton, signupButton]
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

    private func updateSignupButtonConstraint() {
        if let existingConstraint = signupButtonTopConstraint {
            NSLayoutConstraint.deactivate([existingConstraint])
        }

        let newConstraint: NSLayoutConstraint
        if passwordTextFieldErrorLabel.isHidden {
            newConstraint = signupButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16)
        } else {
            newConstraint = signupButton.topAnchor.constraint(equalTo: passwordTextFieldErrorLabel.bottomAnchor, constant: 16)
        }

        NSLayoutConstraint.activate([newConstraint])
        signupButtonTopConstraint = newConstraint
    }

    private func changeButtonState(isEnabled: Bool) {
        signinButton.isEnabled = isEnabled
        signinButton.backgroundColor = isEnabled ? .tinkoffYellow : .tinkoffYellow.withAlphaComponent(0.5)
        signinButton.setTitleColor(isEnabled ? .tinkoffBlack : .tinkoffBlack.withAlphaComponent(0.5), for: .normal)
    }

    // MARK: - Actions
    @objc func tapGesture() {
        passwordTextField.resignFirstResponder()
    }

    private func didTapSignInButton(with password: String?) {
        guard let password = password else { return }
        // Add button press animation
        UIView.animate(withDuration: 0.1, animations: {
            self.signinButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.signinButton.transform = .identity
            }
        }
        
        Auth.shared.signIn(password: password) { [weak self] error in
            DispatchQueue.main.async {
                guard let self else { return }
                if let error = error {
                    // Add shake animation for error
                    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
                    animation.timingFunction = CAMediaTimingFunction(name: .linear)
                    animation.duration = 0.6
                    animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -2.5, 2.5, 0.0]
                    self.passwordTextField.layer.add(animation, forKey: "shake")
                    
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


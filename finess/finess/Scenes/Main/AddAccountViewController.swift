//
//  AddAccountViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 20.04.2025.
//

import UIKit

protocol AddAccountViewControllerDelegate: AnyObject {
    func accountDidCreated()
}

class AddAccountViewController: UIViewController {

    // MARK: - Internal properties
    weak var delegate: AddAccountViewControllerDelegate?

    // MARK: - Private properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("addAccount", comment: "")
        label.font = .tinkoffTitle1()
        label.textAlignment = .center
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Constants.smallSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("recipient", comment: "")
        label.font = .tinkoffHeading()
        label.textAlignment = .center
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("add", comment: ""), for: .normal)
        button.titleLabel?.font = .tinkoffHeading()
        button.setTitleColor(.tinkoffBlack, for: .normal)
        button.backgroundColor = .tinkoffYellow.withAlphaComponent(0.5)
        button.layer.cornerRadius = 25
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            // Add button press animation
            UIView.animate(withDuration: 0.1, animations: {
                self.addAccountButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.addAccountButton.transform = .identity
                }
            }
            
            loadingView.start()
            provider.createAccount(
                ownerName: nameTextField.text,
                inn: innTextField.text,
                bik: bankBikTextField.text,
                accountNumber: cardNumberTextField.text
            ) { [weak self] result in
                DispatchQueue.main.async {
                    self?.loadingView.stop() { [weak self] in
                        guard let self else { return }
                        switch result {
                        case .success(let success):
                            self.delegate?.accountDidCreated()
                        case .failure(let error):
                            self.showError(error, loggingService: self.loggingService)
                        }
                    }
                }
            }
        }), for: .touchUpInside)
        return button
    }()

    private let nameTextField: RegisterTextField = {
        let textField = RegisterTextField(placeholder: NSLocalizedString("name", comment: ""), mode: .required)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.tinkoffBlack.withAlphaComponent(0.1).cgColor
        textField.backgroundColor = .white
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()

    private let cardNumberTextField: RegisterTextField = {
        let textField = RegisterTextField(placeholder: NSLocalizedString("cardNumber", comment: ""), mode: .required)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.tinkoffBlack.withAlphaComponent(0.1).cgColor
        textField.backgroundColor = .white
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()

    private let innTextField: RegisterTextField = {
        let textField = RegisterTextField(placeholder: NSLocalizedString("inn", comment: ""), mode: .required)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.tinkoffBlack.withAlphaComponent(0.1).cgColor
        textField.backgroundColor = .white
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()

    private let bankBikTextField: RegisterTextField = {
        let textField = RegisterTextField(placeholder: NSLocalizedString("bankBik", comment: ""), mode: .required)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.tinkoffBlack.withAlphaComponent(0.1).cgColor
        textField.backgroundColor = .white
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()

    private let provider: QRProvider
    private let loadingView = LoadingView()
    private let loggingService = APILoggingService()

    init(provider: QRProvider) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
        nameTextField.delegate = self
        cardNumberTextField.delegate = self
        innTextField.delegate = self
        bankBikTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateUIElements()
    }

    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(subtitleLabel)
        contentStackView.addArrangedSubview(nameTextField)
        contentStackView.addArrangedSubview(cardNumberTextField)
        contentStackView.addArrangedSubview(innTextField)
        contentStackView.addArrangedSubview(bankBikTextField)
        view.addSubview(addAccountButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            contentStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            addAccountButton.heightAnchor.constraint(equalToConstant: 50),
            addAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addAccountButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: Constants.smallSpacing)
        ])

        nameTextField.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
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
        let views = [contentStackView, addAccountButton]
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

    private func changeButtonState(isEnabled: Bool) {
        addAccountButton.isEnabled = isEnabled
        addAccountButton.backgroundColor = isEnabled ? .tinkoffYellow : .tinkoffYellow.withAlphaComponent(0.5)
        addAccountButton.setTitleColor(isEnabled ? .tinkoffBlack : .tinkoffBlack.withAlphaComponent(0.5), for: .normal)
    }

    // MARK: - Actions
    @objc func tapGesture() {
        nameTextField.resignFirstResponder()
        cardNumberTextField.resignFirstResponder()
        innTextField.resignFirstResponder()
        bankBikTextField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension AddAccountViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let nameTextFieldIsEmpty = nameTextField.text?.isEmpty ?? true
        let cardNumberTextFieldIsEmpty = cardNumberTextField.text?.isEmpty ?? true
        let innTextFieldIsEmpty = innTextField.text?.isEmpty ?? true
        let bankBikTextField = bankBikTextField.text?.isEmpty ?? true

        if !nameTextFieldIsEmpty &&
            !cardNumberTextFieldIsEmpty &&
            !innTextFieldIsEmpty &&
            !bankBikTextField {
            changeButtonState(isEnabled: true)
        } else {
            changeButtonState(isEnabled: false)
        }
    }
}

//
//  CreateQRViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 20.04.2025.
//

import UIKit

class CreateQRViewController: UIViewController {

    // MARK: - Private properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.qrIconTitle
        label.font = Constants.titleFont
        label.textAlignment = Constants.textAlignment
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.addAccount
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
        label.text = Constants.recipient
        label.font = Constants.smallButtonFont
        label.textAlignment = Constants.textAlignment
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var createQRButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.add, for: .normal)
        button.titleLabel?.font = Constants.largeButtonFont
        button.setTitleColor(Constants.buttonTitleColor, for: .normal)
        button.backgroundColor = Constants.disabledButtonColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            provider.createAccount(
                ownerName: nameTextField.text,
                inn: innTextField.text,
                bik: bankBikTextField.text,
                accountNumber: cardNumberTextField.text
            )
        }), for: .touchUpInside)
        return button
    }()

    private let nameTextField = RegisterTextField(placeholder: Constants.name, mode: .required)
    private let cardNumberTextField = RegisterTextField(placeholder: Constants.cardNumber, mode: .required)
    private let innTextField = RegisterTextField(placeholder: Constants.inn, mode: .required)
    private let bankBikTextField = RegisterTextField(placeholder: Constants.bankBik, mode: .required)

    private let provider = QRProvider()

    init() {
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

    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        view.addSubview(titleLabel)
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(subtitleLabel)
        contentStackView.addArrangedSubview(nameTextField)
        contentStackView.addArrangedSubview(cardNumberTextField)
        contentStackView.addArrangedSubview(innTextField)
        contentStackView.addArrangedSubview(bankBikTextField)
        view.addSubview(createQRButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),

            contentStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.largeSpacing),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),

            createQRButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: Constants.mediumSpacing),
            createQRButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            createQRButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            createQRButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
        ])

        nameTextField.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
    }

    private func changeButtonState(isEnabled: Bool) {
        createQRButton.isEnabled = isEnabled
        createQRButton.backgroundColor = isEnabled ? Constants.activeButtonColor: Constants.disabledButtonColor
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
extension CreateQRViewController: UITextFieldDelegate {
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

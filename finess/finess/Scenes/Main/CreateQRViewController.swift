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
        label.text = "Создать QR"
        return label
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Получатель"
        label.font = Constants.smallButtonFont
        label.textAlignment = Constants.textAlignment
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var createQRButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
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

    private let nameTextField = RegisterTextField(placeholder: "Имя", mode: .required)
    private let cardNumberTextField = RegisterTextField(placeholder: "Номер карты или счёта", mode: .required)
    private let innTextField = RegisterTextField(placeholder: "ИНН", mode: .required)
    private let bankBikTextField = RegisterTextField(placeholder: "БИК банка", mode: .required)

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
        nameTextField.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
        setupUI()
    }

    // MARK: - Private methods
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(subtitleLabel)
        contentStackView.addArrangedSubview(nameTextField)
        contentStackView.addArrangedSubview(cardNumberTextField)
        contentStackView.addArrangedSubview(innTextField)
        contentStackView.addArrangedSubview(bankBikTextField)
        view.addSubview(createQRButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            contentStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            createQRButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 32),
            createQRButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            createQRButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createQRButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
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

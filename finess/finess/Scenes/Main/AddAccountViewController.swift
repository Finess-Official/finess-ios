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
        label.font = Constants.titleFont
        label.textAlignment = Constants.textAlignment
        label.textColor = Constants.textColor
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
        label.font = Constants.smallButtonFont
        label.textAlignment = Constants.textAlignment
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("add", comment: ""), for: .normal)
        button.titleLabel?.font = Constants.largeButtonFont
        button.setTitleColor(Constants.buttonTitleColor, for: .normal)
        button.backgroundColor = Constants.disabledButtonColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            loadingViewController.start()
            provider.createAccount(
                ownerName: nameTextField.text,
                inn: innTextField.text,
                bik: bankBikTextField.text,
                accountNumber: cardNumberTextField.text
            ) { [weak self] result in
                DispatchQueue.main.async {
                    self?.loadingViewController.stop() { [weak self] in
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


    private let nameTextField = RegisterTextField(placeholder: NSLocalizedString("name", comment: ""), mode: .required)
    private let cardNumberTextField = RegisterTextField(placeholder: NSLocalizedString("cardNumber", comment: ""), mode: .required)
    private let innTextField = RegisterTextField(placeholder: NSLocalizedString("inn", comment: ""), mode: .required)
    private let bankBikTextField = RegisterTextField(placeholder: NSLocalizedString("bankBIK", comment: ""), mode: .required)
    private let provider: QRProvider
    private let loadingViewController = LoadingViewController()
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
        view.addSubview(addAccountButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),

            contentStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.largeSpacing),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),

            addAccountButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: Constants.mediumSpacing),
            addAccountButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            addAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            addAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
        ])

        nameTextField.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
    }

    private func changeButtonState(isEnabled: Bool) {
        addAccountButton.isEnabled = isEnabled
        addAccountButton.backgroundColor = isEnabled ? Constants.activeButtonColor: Constants.disabledButtonColor
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

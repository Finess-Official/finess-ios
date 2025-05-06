//
//  CreateQRViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 27.04.2025.
//

import UIKit

protocol CreateQRViewControllerDelegate: AnyObject {
    func didTapCreateButton()
}

class CreateQRViewController: UIViewController {

    // MARK: - Internal properties
    weak var delegate: CreateQRViewControllerDelegate?

    // MARK: - Private properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("createQR", comment: "")
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
        label.text = NSLocalizedString("enterSumm", comment: "")
        label.font = Constants.smallButtonFont
        label.textAlignment = Constants.textAlignment
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var createQRButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("create", comment: ""), for: .normal)
        button.titleLabel?.font = Constants.largeButtonFont
        button.setTitleColor(Constants.buttonTitleColor, for: .normal)
        button.backgroundColor = Constants.disabledButtonColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            loadingViewController.start()
            provider.createQR(amount: summTextField.text) { [weak self] result in
                DispatchQueue.main.async {
                    self?.loadingViewController.stop() { [weak self] in
                        switch result {
                        case .success(let success):
                            self?.delegate?.didTapCreateButton()
                        case .failure(let error):
                            self?.showError(error)
                        }
                    }
                }
            }
            delegate?.didTapCreateButton()
        }), for: .touchUpInside)
        return button
    }()

    private let summTextField = RegisterTextField(placeholder: NSLocalizedString("summToTransfer", comment: ""), mode: .required)
    private let provider: QRProvider
    private let loadingViewController = LoadingViewController()

    init(provider: QRProvider) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
        summTextField.delegate = self
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
        contentStackView.addArrangedSubview(summTextField)
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

        summTextField.becomeFirstResponder()
        summTextField.keyboardType = .decimalPad
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
    }

    private func changeButtonState(isEnabled: Bool) {
        createQRButton.isEnabled = isEnabled
        createQRButton.backgroundColor = isEnabled ? Constants.activeButtonColor: Constants.disabledButtonColor
    }

    // MARK: - Actions
    @objc func tapGesture() {
        summTextField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension CreateQRViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let summTextFieldIsEmpty = summTextField.text?.isEmpty ?? true

        if !summTextFieldIsEmpty {
            changeButtonState(isEnabled: true)
        } else {
            changeButtonState(isEnabled: false)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)

        return replacementText.isValidDecimal(maximumFractionDigits: Constants.maximumFractionDigits)

    }
}

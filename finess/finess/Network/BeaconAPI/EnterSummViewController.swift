//
//  CreateQRViewControllerDelegate.swift
//  finess
//
//  Created by Elina Karapetyan on 21.05.2025.
//

import UIKit

protocol EnterSummViewControllerDelegate: AnyObject {
    func didTapCreateButton(uuid: String, major: UInt16, minor: UInt16)
}

class EnterSummViewController: UIViewController {

    // MARK: - Internal properties
    weak var delegate: EnterSummViewControllerDelegate?

    // MARK: - Private properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("startBroadcasting", comment: "")
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
        label.text = NSLocalizedString("enterSumm", comment: "")
        label.font = .tinkoffHeading()
        label.textAlignment = .center
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let summTextField: RegisterTextField = {
        let textField = RegisterTextField(placeholder: NSLocalizedString("summ", comment: ""), mode: .required)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.tinkoffBlack.withAlphaComponent(0.1).cgColor
        textField.backgroundColor = .white
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()

    private lazy var createQRButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("start", comment: ""), for: .normal)
        button.titleLabel?.font = .tinkoffHeading()
        button.setTitleColor(.tinkoffBlack, for: .normal)
        button.backgroundColor = .tinkoffYellow.withAlphaComponent(0.5)
        button.layer.cornerRadius = 25
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            UIView.animate(withDuration: 0.1, animations: {
                self.createQRButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.createQRButton.transform = .identity
                }
            }
            
            loadingView.start()
            didTapCreateButton()
        }), for: .touchUpInside)
        return button
    }()

    private let provider: BeaconProvider
    private let loadingView = LoadingView()
    private let loggingService = APILoggingService()

    init(provider: BeaconProvider) {
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
        contentStackView.addArrangedSubview(summTextField)
        view.addSubview(createQRButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            contentStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            createQRButton.heightAnchor.constraint(equalToConstant: 50),
            createQRButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createQRButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: createQRButton.bottomAnchor, constant: 20)
        ])

        summTextField.becomeFirstResponder()
        summTextField.keyboardType = .decimalPad
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
        let views = [contentStackView, createQRButton]
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
        createQRButton.isEnabled = isEnabled
        createQRButton.backgroundColor = isEnabled ? .tinkoffYellow : .tinkoffYellow.withAlphaComponent(0.5)
        createQRButton.setTitleColor(isEnabled ? .tinkoffBlack : .tinkoffBlack.withAlphaComponent(0.5), for: .normal)
    }

    private func didTapCreateButton() {
        guard let amount = summTextField.text, let floatValue = Float(amount) else { return }

        provider.createBeacon(amount: floatValue) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let beacon):
                self.delegate?.didTapCreateButton(uuid: beacon.bluetoothId, major: beacon.major, minor: beacon.minor)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    // MARK: - Actions
    @objc func tapGesture() {
        summTextField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension EnterSummViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if summTextField.text?.isEmpty ?? true {
            changeButtonState(isEnabled: false)
        } else {
            changeButtonState(isEnabled: true)
        }
    }
}

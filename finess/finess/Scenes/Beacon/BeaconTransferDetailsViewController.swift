//
//  BeaconTransferDetailsViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 22.05.2025.
//

import UIKit

class BeaconTransferDetailsViewController: UIViewController {

    private let id: String

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("transferDetails", comment: "")
        label.font = Constants.titleFont
        label.textAlignment = Constants.textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.textColor
        return label
    }()

    private let recipientTitle: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("recipientTitle", comment: "")
        label.font = Constants.subtitleFont
        label.textAlignment = Constants.textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.transparentTextColor
        return label
    }()

    private let recipient: UILabel = {
        let label = UILabel()
        label.font = Constants.subtitleFont
        label.textAlignment = Constants.textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.textColor
        return label
    }()

    private let cardNumberTitle: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("cardNumberTitle", comment: "")
        label.font = Constants.subtitleFont
        label.textAlignment = Constants.textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.transparentTextColor
        return label
    }()

    private let cardNumber: UILabel = {
        let label = UILabel()
        label.font = Constants.subtitleFont
        label.textAlignment = Constants.textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.textColor
        return label
    }()

    private lazy var transferButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("transferAction", comment: ""), for: .normal)
        button.backgroundColor = .tinkoffYellow
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .tinkoffBody()
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(transferButtonTapped), for: .touchUpInside)
        return button
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let provider = QRProvider()
    private let loggingService = APILoggingService()
    private let loadingView = LoadingView()

    init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    func configure(name: String, cardNumber: String) {
        self.recipient.text = name
        self.cardNumber.text = cardNumber
    }

    private func setupUI() {
        loadingView.isHidden = true
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(recipientTitle)
        let recipientContainer = UIView()
        recipientContainer.translatesAutoresizingMaskIntoConstraints = false
        recipient.translatesAutoresizingMaskIntoConstraints = false
        recipientContainer.addSubview(recipient)
        NSLayoutConstraint.activate([
            recipient.topAnchor.constraint(equalTo: recipientContainer.topAnchor),
            recipient.leadingAnchor.constraint(equalTo: recipientContainer.leadingAnchor),
            recipient.trailingAnchor.constraint(equalTo: recipientContainer.trailingAnchor),
            recipient.bottomAnchor.constraint(equalTo: recipientContainer.bottomAnchor),
        ])
        contentStackView.addArrangedSubview(recipientContainer)
        contentStackView.addArrangedSubview(cardNumberTitle)
        let cardNumberContainer = UIView()
        cardNumberContainer.translatesAutoresizingMaskIntoConstraints = false
        cardNumber.translatesAutoresizingMaskIntoConstraints = false
        cardNumberContainer.addSubview(cardNumber)
        NSLayoutConstraint.activate([
            cardNumber.topAnchor.constraint(equalTo: cardNumberContainer.topAnchor),
            cardNumber.leadingAnchor.constraint(equalTo: cardNumberContainer.leadingAnchor),
            cardNumber.trailingAnchor.constraint(equalTo: cardNumberContainer.trailingAnchor),
            cardNumber.bottomAnchor.constraint(equalTo: cardNumberContainer.bottomAnchor),
        ])
        contentStackView.addArrangedSubview(cardNumberContainer)
        let transferSummContainer = UIView()
        transferSummContainer.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(transferSummContainer)
        view.addSubview(titleLabel)
        view.addSubview(transferButton)
        view.addSubview(loadingView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            contentStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            transferButton.heightAnchor.constraint(equalToConstant: 50),
            transferButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            transferButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            transferButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),

            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func transferButtonTapped() {
        loadingView.start()
        loadingView.isHidden = false
        provider.initializePaymentBeacon(qrCodeId: id, type: .beacon) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let task):
                if let url = task.acquiringPaymentUrl {
                    DispatchQueue.main.async {
                        self.loadingView.stop {
                            self.loadingView.isHidden = true
                            if let url = URL(string: url) {
                                let paymentVC = PaymentWebViewController(url: url)
                                paymentVC.modalPresentationStyle = .fullScreen
                                self.present(paymentVC, animated: true)
                            }
                        }
                    }
                } else {
                    provider.getPaymentInitStatus(paymentTaskId: task.id) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let acquiringPaymentUrl):
                            DispatchQueue.main.async {
                                self.loadingView.stop {
                                    self.loadingView.isHidden = true
                                    if let url = acquiringPaymentUrl {
                                        if let url = URL(string: url) {
                                            let paymentVC = PaymentWebViewController(url: url)
                                            self.present(paymentVC, animated: true)
                                        }
                                    }
                                }
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.loadingView.stop {
                                    self.loadingView.isHidden = true
                                    self.showError(error, loggingService: self.loggingService)
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.loadingView.stop {
                        self.loadingView.isHidden = true
                        self.showError(error, loggingService: self.loggingService)
                    }
                }
            }
        }
    }

}

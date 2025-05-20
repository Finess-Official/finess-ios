//
//  TransferDetailsViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 11.05.2025.
//

import UIKit

class TransferDetailsViewController: UIViewController {

    private let qrCodeId: String

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

    private let transferSummTitle: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("transferSummTitle", comment: "")
        label.font = Constants.subtitleFont
        label.textAlignment = Constants.textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.transparentTextColor
        return label
    }()

    private let transferSumm: UILabel = {
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

    private let loadingView = LoadingView()
    private let provider = QRProvider()
    private let loggingService = APILoggingService()

    init(qrCodeId: String) {
        self.qrCodeId = qrCodeId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchTransferDetails()
    }

    private func setupUI() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.configure()
        loadingView.isHidden = true
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(recipientTitle)
        contentStackView.addArrangedSubview(recipient)
        contentStackView.addArrangedSubview(cardNumberTitle)
        contentStackView.addArrangedSubview(cardNumber)
        contentStackView.addArrangedSubview(transferSummTitle)
        contentStackView.addArrangedSubview(transferSumm)
        view.addSubview(titleLabel)
        view.addSubview(loadingView)
        view.addSubview(transferButton)

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

            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        contentStackView.setCustomSpacing(24, after: transferSumm)
    }

    private func fetchTransferDetails() {
        loadingView.isHidden = false
        loadingView.start()
        provider.getQR(qrCodeId: qrCodeId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let success):
                    self.transferSumm.text = "\(success) ₽"
                case .failure(let failure):
                    self.loadingView.stop {
                        self.showError(failure, loggingService: self.loggingService)
                        self.loadingView.isHidden = true
                    }
                }
            }
        } accountCompletion: { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.loadingView.stop {
                    switch result {
                    case .success(let success):
                        self.cardNumber.text = success.cardNumber
                        self.recipient.text = success.name
                        self.loadingView.isHidden = true
                    case .failure(let failure):
                        self.showError(failure, loggingService: self.loggingService)
                    }
                }
            }
        }
    }

    @objc private func transferButtonTapped() {
        loadingView.isHidden = false
        loadingView.start()
        
        provider.initializePayment(qrCodeId: qrCodeId) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loadingView.stop { [weak self] in
                    guard let self = self else { return }

                    switch result {
                    case .success(let task):
                        if let url = task.acquiringPaymentUrl {
                            loadingView.isHidden = true
                            if let url = URL(string: url) {
                                UIApplication.shared.open(url)
                            }
                        } else {
                            provider.getPaymentInitStatus(paymentTaskId: task.id) { [weak self] result in
                                guard let self = self else { return }
                                switch result {
                                case .success(let acquiringPaymentUrl):
                                    DispatchQueue.main.async {
                                        if let url = acquiringPaymentUrl {
                                            self.loadingView.isHidden = true
                                            let testurl = "http://51.250.29.29:8081/payment/form/1"
                                            if let url = URL(string: testurl) {
                                                UIApplication.shared.open(url)
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    loadingView.isHidden = true
                                    self.showError(error, loggingService: self.loggingService)
                                }
                            }
                        }
                    case .failure(let error):
                        loadingView.isHidden = true
                        self.showError(error, loggingService: self.loggingService)
                    }
                }
            }
        }
    }

}

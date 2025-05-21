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

    private let provider = QRProvider()
    private let loggingService = APILoggingService()

    private let recipientShimmer = ShimmerView()
    private let cardNumberShimmer = ShimmerView()
    private let transferSummShimmer = ShimmerView()

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
        startShimmers()
        fetchTransferDetails()
    }

    private func setupUI() {
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(recipientTitle)
        let recipientContainer = UIView()
        recipientContainer.translatesAutoresizingMaskIntoConstraints = false
        recipient.translatesAutoresizingMaskIntoConstraints = false
        recipientShimmer.translatesAutoresizingMaskIntoConstraints = false
        recipientContainer.addSubview(recipient)
        recipientContainer.addSubview(recipientShimmer)
        NSLayoutConstraint.activate([
            recipient.topAnchor.constraint(equalTo: recipientContainer.topAnchor),
            recipient.leadingAnchor.constraint(equalTo: recipientContainer.leadingAnchor),
            recipient.trailingAnchor.constraint(equalTo: recipientContainer.trailingAnchor),
            recipient.bottomAnchor.constraint(equalTo: recipientContainer.bottomAnchor),
            recipientShimmer.topAnchor.constraint(equalTo: recipientContainer.topAnchor),
            recipientShimmer.leadingAnchor.constraint(equalTo: recipientContainer.leadingAnchor),
            recipientShimmer.trailingAnchor.constraint(equalTo: recipientContainer.trailingAnchor),
            recipientShimmer.bottomAnchor.constraint(equalTo: recipientContainer.bottomAnchor),
            recipientShimmer.heightAnchor.constraint(equalToConstant: 32)
        ])
        contentStackView.addArrangedSubview(recipientContainer)
        contentStackView.addArrangedSubview(cardNumberTitle)
        let cardNumberContainer = UIView()
        cardNumberContainer.translatesAutoresizingMaskIntoConstraints = false
        cardNumber.translatesAutoresizingMaskIntoConstraints = false
        cardNumberShimmer.translatesAutoresizingMaskIntoConstraints = false
        cardNumberContainer.addSubview(cardNumber)
        cardNumberContainer.addSubview(cardNumberShimmer)
        NSLayoutConstraint.activate([
            cardNumber.topAnchor.constraint(equalTo: cardNumberContainer.topAnchor),
            cardNumber.leadingAnchor.constraint(equalTo: cardNumberContainer.leadingAnchor),
            cardNumber.trailingAnchor.constraint(equalTo: cardNumberContainer.trailingAnchor),
            cardNumber.bottomAnchor.constraint(equalTo: cardNumberContainer.bottomAnchor),
            cardNumberShimmer.topAnchor.constraint(equalTo: cardNumberContainer.topAnchor),
            cardNumberShimmer.leadingAnchor.constraint(equalTo: cardNumberContainer.leadingAnchor),
            cardNumberShimmer.trailingAnchor.constraint(equalTo: cardNumberContainer.trailingAnchor),
            cardNumberShimmer.bottomAnchor.constraint(equalTo: cardNumberContainer.bottomAnchor),
            cardNumberShimmer.heightAnchor.constraint(equalToConstant: 32)
        ])
        contentStackView.addArrangedSubview(cardNumberContainer)
        contentStackView.addArrangedSubview(transferSummTitle)
        let transferSummContainer = UIView()
        transferSummContainer.translatesAutoresizingMaskIntoConstraints = false
        transferSumm.translatesAutoresizingMaskIntoConstraints = false
        transferSummShimmer.translatesAutoresizingMaskIntoConstraints = false
        transferSummContainer.addSubview(transferSumm)
        transferSummContainer.addSubview(transferSummShimmer)
        NSLayoutConstraint.activate([
            transferSumm.topAnchor.constraint(equalTo: transferSummContainer.topAnchor),
            transferSumm.leadingAnchor.constraint(equalTo: transferSummContainer.leadingAnchor),
            transferSumm.trailingAnchor.constraint(equalTo: transferSummContainer.trailingAnchor),
            transferSumm.bottomAnchor.constraint(equalTo: transferSummContainer.bottomAnchor),
            transferSummShimmer.topAnchor.constraint(equalTo: transferSummContainer.topAnchor),
            transferSummShimmer.leadingAnchor.constraint(equalTo: transferSummContainer.leadingAnchor),
            transferSummShimmer.trailingAnchor.constraint(equalTo: transferSummContainer.trailingAnchor),
            transferSummShimmer.bottomAnchor.constraint(equalTo: transferSummContainer.bottomAnchor),
            transferSummShimmer.heightAnchor.constraint(equalToConstant: 32)
        ])
        contentStackView.addArrangedSubview(transferSummContainer)
        view.addSubview(titleLabel)
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
            transferButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
        contentStackView.setCustomSpacing(24, after: transferSumm)
    }

    private func startShimmers() {
        recipientShimmer.isHidden = false
        cardNumberShimmer.isHidden = false
        transferSummShimmer.isHidden = false
        recipient.isHidden = true
        cardNumber.isHidden = true
        transferSumm.isHidden = true
        recipientShimmer.startShimmering()
        cardNumberShimmer.startShimmering()
        transferSummShimmer.startShimmering()
    }

    private func stopShimmers() {
        recipientShimmer.stopShimmering()
        cardNumberShimmer.stopShimmering()
        transferSummShimmer.stopShimmering()
        recipientShimmer.isHidden = true
        cardNumberShimmer.isHidden = true
        transferSummShimmer.isHidden = true
        recipient.isHidden = false
        cardNumber.isHidden = false
        transferSumm.isHidden = false
    }

    private func fetchTransferDetails() {
        provider.getQR(qrCodeId: qrCodeId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let success):
                    self.transferSumm.text = "\(success) ₽"
                    self.stopShimmers()
                case .failure(let failure):
                    self.showError(failure, loggingService: self.loggingService)
                    self.stopShimmers()
                }
            }
        } accountCompletion: { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.cardNumber.text = success.cardNumber
                    self.recipient.text = success.name
                    self.stopShimmers()
                case .failure(let failure):
                    self.showError(failure, loggingService: self.loggingService)
                    self.stopShimmers()
                }
            }
        }
    }

    @objc private func transferButtonTapped() {
        provider.initializePayment(qrCodeId: qrCodeId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let task):
                if let url = task.acquiringPaymentUrl {
                    DispatchQueue.main.async {
                        if let url = URL(string: url) {
                            let paymentVC = PaymentWebViewController(url: url)
                            paymentVC.modalPresentationStyle = .fullScreen
                            self.present(paymentVC, animated: true)
                        }
                    }
                } else {
                    provider.getPaymentInitStatus(paymentTaskId: task.id) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let acquiringPaymentUrl):
                            DispatchQueue.main.async {
                                if let url = acquiringPaymentUrl {
                                    if let url = URL(string: url) {
                                        let paymentVC = PaymentWebViewController(url: url)
                                        self.present(paymentVC, animated: true)
                                    }
                                }
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.showError(error, loggingService: self.loggingService)
                            }
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showError(error, loggingService: self.loggingService)
                }
            }
        }
    }

}

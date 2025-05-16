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
        label.text = "Карапетян Элина Камоевна"
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
        label.text = "12345678901234567890"
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
        label.text = "122 ₽"
        label.font = Constants.subtitleFont
        label.textAlignment = Constants.textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.textColor
        return label
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
        view.backgroundColor = Constants.backgroundColor
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

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),

            contentStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.largeSpacing),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),

            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func fetchTransferDetails() {
        loadingView.isHidden = false
        loadingView.start()
//        provider.getQR(qrCodeId: qrCodeId) { [weak self] result in
//            guard let self else { return }
//            DispatchQueue.main.async {
//                self.loadingViewController.stop { [weak self] in
//                    guard let self else { return }
//                    switch result {
//                    case .success(let success):
//                        self.transferSumm.text = "\(success.transferSumm) ₽"
//                    case .failure(let failure):
//                        self.showError(failure, loggingService: self.loggingService)
//                    }
//                }
//            }
//        }
    }
}

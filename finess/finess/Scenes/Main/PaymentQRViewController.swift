//
//  PaymentQRViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 03.05.2025.
//

import UIKit
import LinkPresentation

class PaymentQRViewController: UIViewController {

    private let qrCodeId: String

    private lazy var qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var returnToMainButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("returnToMain", comment: ""), for: .normal)
        button.titleLabel?.font = .tinkoffHeading()
        button.setTitleColor(.tinkoffBlack, for: .normal)
        button.backgroundColor = .tinkoffYellow
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            // Add button press animation
            UIView.animate(withDuration: 0.1, animations: {
                self.returnToMainButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.returnToMainButton.transform = .identity
                }

                if let url = URL(string: "finesspay://main_screen") {
                    UIApplication.shared.open(url)
                }
            }
        }), for: .touchUpInside)
        return button
    }()

    init(qrCodeId: String) {
        self.qrCodeId = qrCodeId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        qrCodeImageView.image = generateQRCode(from: "finess://payment-qr?qrCodeId=\(qrCodeId)")
    }

    private func setupUI() {
        let rightMenuItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        self.navigationItem.setRightBarButton(rightMenuItem, animated: false)

        view.backgroundColor = Constants.backgroundColor

        view.addSubview(qrCodeImageView)
        view.addSubview(returnToMainButton)

        NSLayoutConstraint.activate([
            qrCodeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrCodeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            qrCodeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            qrCodeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            qrCodeImageView.topAnchor.constraint(equalTo: view.topAnchor),

            returnToMainButton.heightAnchor.constraint(equalToConstant: 50),
            returnToMainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            returnToMainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            returnToMainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator")
        {
            filter.setValue(data, forKey: "inputMessage")

            guard let qrImage = filter.outputImage else {return nil}
            let scale = self.qrCodeImageView.frame.size.width / qrImage.extent.size.width
            let transform = CGAffineTransform(scaleX: scale, y: scale)

            if let output = filter.outputImage?.transformed(by: transform)
            {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }

    // MARK: - Actions
    @objc func shareButtonTapped() {
        let activityItem: [AnyObject] = [self, self.qrCodeImageView.image!]
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        present(avc, animated: true, completion: nil)
    }
} 

extension PaymentQRViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let image = UIImage(named: "AppIcon")!
        let imageProvider = NSItemProvider(object: image)
        let metadata = LPLinkMetadata()
        metadata.imageProvider = imageProvider
        return metadata
    }
}

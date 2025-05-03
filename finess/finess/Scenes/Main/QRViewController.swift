//
//  QRViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 03.05.2025.
//

import UIKit

class QRViewController: UIViewController {

    private let accountId: String

    private lazy var qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(accountId: String) {
        self.accountId = accountId
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
        qrCodeImageView.image = generateQRCode(from: "finess://payment-qr?accountId=\(accountId)")
    }

    private func setupUI() {
        let rightMenuItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        self.navigationItem.setRightBarButton(rightMenuItem, animated: false)

        view.backgroundColor = Constants.backgroundColor

        view.addSubview(qrCodeImageView)

        NSLayoutConstraint.activate([
            qrCodeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrCodeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            qrCodeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            qrCodeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            qrCodeImageView.topAnchor.constraint(equalTo: view.topAnchor)
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
        let activityItem: [AnyObject] = [self.qrCodeImageView.image!]
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        present(avc, animated: true, completion: nil)
    }
}

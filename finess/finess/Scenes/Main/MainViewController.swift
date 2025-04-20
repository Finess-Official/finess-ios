//
//  MainViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 10.04.2025.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Private properties
//    private lazy var qrCodeImageView: UIImageView = {
//        let imageView = UIImageView(image: genQRCode(from: "some string that we want to put into QR code"))
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.qrIconTitle
        label.font = Constants.titleFont
        label.textAlignment = Constants.textAlignment
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let createQRCodeButton: MainViewButton = {
        let button = MainViewButton(title: "Создать", image: Constants.addIcon)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let scanQRCodeButton: MainViewButton = {
        let button = MainViewButton(title: "Сканировать", image: Constants.qrIcon)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.backgroundColor
        view.addSubview(titleLabel)
        view.addSubview(createQRCodeButton)
        view.addSubview(scanQRCodeButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            createQRCodeButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            createQRCodeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createQRCodeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createQRCodeButton.heightAnchor.constraint(equalToConstant: 105),

            scanQRCodeButton.topAnchor.constraint(equalTo: createQRCodeButton.bottomAnchor, constant: 32),
            scanQRCodeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scanQRCodeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scanQRCodeButton.heightAnchor.constraint(equalToConstant: 105),
        ])
    }

    func genQRCode(from input: String) -> UIImage? {
        let data = input.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}

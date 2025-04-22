//
//  MainViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 10.04.2025.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func didTapLogout()
}

class MainViewController: UIViewController {

    weak var delegate: MainViewControllerDelegate?

    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.didTapLogout()
        }), for: .touchUpInside)
        return button
    }()

    private lazy var qrCodeImageView: UIImageView = {
        let imageView = UIImageView(image: genQRCode(from: "some string that we want to put into QR code"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        view.addSubview(logoutButton)
        view.addSubview(qrCodeImageView)
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            qrCodeImageView.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 30),

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

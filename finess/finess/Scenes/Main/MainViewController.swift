//
//  MainViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 10.04.2025.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func didTapCreateQRCodeButton()
}

class MainViewController: UIViewController {

    // MARK: - Internal properties
    weak var delegate: MainViewControllerDelegate?

    // MARK: - Private properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.qrIconTitle
        label.font = Constants.titleFont
        label.textAlignment = Constants.textAlignment
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var createQRCodeButton: MainViewButton = {
        let button = MainViewButton(title: Constants.create, image: Constants.addIcon)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.didTapCreateQRCodeButton()
        }), for: .touchUpInside)
        return button
    }()

    private let scanQRCodeButton: MainViewButton = {
        let button = MainViewButton(title: Constants.scan, image: Constants.qrIcon)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        view.addSubview(titleLabel)
        view.addSubview(createQRCodeButton)
        view.addSubview(scanQRCodeButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),

            createQRCodeButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.mediumSpacing),
            createQRCodeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            createQRCodeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            createQRCodeButton.heightAnchor.constraint(equalToConstant: Constants.mainViewButtonHeight),

            scanQRCodeButton.topAnchor.constraint(equalTo: createQRCodeButton.bottomAnchor, constant: Constants.mediumSpacing),
            scanQRCodeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            scanQRCodeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            scanQRCodeButton.heightAnchor.constraint(equalToConstant: Constants.mainViewButtonHeight),
        ])
    }
}

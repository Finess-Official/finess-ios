//
//  MainViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 10.04.2025.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func didTapCreateQRCodeButton()
    func didTapScanQRCodeButton()
}

class MainViewController: UIViewController {

    // MARK: - Internal properties
    weak var delegate: MainViewControllerDelegate?

    // MARK: - Private properties    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("QRTitle", comment: "")
        label.font = .tinkoffTitle1()
        label.textAlignment = .center
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.mediumSpacing
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var createQRCodeButton: MainViewButton = {
        let button = MainViewButton(title: NSLocalizedString("create", comment: ""), image: Constants.addIcon)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTinkoffShadow()
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.animateButtonTap(button)
            self?.delegate?.didTapCreateQRCodeButton()
        }), for: .touchUpInside)
        return button
    }()

    private lazy var scanQRCodeButton: MainViewButton = {
        let button = MainViewButton(title: NSLocalizedString("scan", comment: ""), image: Constants.qrIcon)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTinkoffShadow()
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.animateButtonTap(button)
            self?.delegate?.didTapScanQRCodeButton()
        }), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateUIElements()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(createQRCodeButton)
        buttonsStackView.addArrangedSubview(scanQRCodeButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),

            buttonsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            
            createQRCodeButton.heightAnchor.constraint(equalToConstant: 80),
            scanQRCodeButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func animateUIElements() {
        // Начальное состояние
        titleLabel.alpha = 0
        buttonsStackView.alpha = 0
        
        // Анимация заголовка
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            options: [],
            animations: {
                self.titleLabel.alpha = 1
            }
        )
        
        // Анимация кнопок (fade-in)
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            options: [],
            animations: {
                self.buttonsStackView.alpha = 1
            }
        )
    }
    
    private func animateButtonTap(_ button: UIButton) {
        UIView.animate(
            withDuration: 0.1,
            animations: {
                button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    button.transform = .identity
                }
            }
        )
    }
}

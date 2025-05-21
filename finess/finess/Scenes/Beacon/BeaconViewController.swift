//
//  BeaconViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 21.05.2025.
//

import UIKit

protocol BeaconViewControllerDelegate: AnyObject {
    func didTapBroadcastButton()
    func didTapScanButton()
}

class BeaconViewController: UIViewController {
    weak var delegate: BeaconViewControllerDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("BeaconTitle", comment: "")
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

    private lazy var broadcastButton: MainViewButton = {
        let button = MainViewButton(title: NSLocalizedString("broadcast", comment: ""), image: UIImage(systemName: "dot.radiowaves.left.and.right"))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTinkoffShadow()
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.animateButtonTap(button)
            self?.delegate?.didTapBroadcastButton()
        }), for: .touchUpInside)
        return button
    }()

    private lazy var scanButton: MainViewButton = {
        let button = MainViewButton(title: NSLocalizedString("scan", comment: ""), image: UIImage(systemName: "wave.3.right"))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTinkoffShadow()
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.animateButtonTap(button)
            self?.delegate?.didTapScanButton()
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

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(broadcastButton)
        buttonsStackView.addArrangedSubview(scanButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),

            buttonsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            broadcastButton.heightAnchor.constraint(equalToConstant: 80),
            scanButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func animateUIElements() {
        titleLabel.alpha = 0
        buttonsStackView.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
        UIView.animate(withDuration: 0.6, delay: 0, options: [], animations: {
            self.titleLabel.alpha = 1
        })
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: [], animations: {
            self.buttonsStackView.transform = .identity
        })
    }

    private func animateButtonTap(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

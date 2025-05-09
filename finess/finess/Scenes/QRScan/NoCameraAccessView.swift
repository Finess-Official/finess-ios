//
//  NoCameraAccessView.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import UIKit

final class NoCameraAccessView: UIView {
    var didTapOpenSettingsButton: (() -> Void)?

    init() {
        super.init(frame: .zero)

        let titleLabel = UILabel()
        let subtitleLabel = UILabel()

        let settingsButton = UIButton()

        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = NSLocalizedString("сameraAccess", comment: "")

        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = .white
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = NSLocalizedString("scanAndTransfer", comment: "")

        let m = 8.0

        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.setTitle(
            NSLocalizedString("openSettings", comment: ""),
            for: .normal
        )
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        settingsButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.didTapOpenSettingsButton?()
                }
            ),
            for: .touchUpInside
        )

        [titleLabel, subtitleLabel, settingsButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let constraints = [
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: m * 2),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -m * 2),

            subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: m * 2),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: m),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -m * 2),
            subtitleLabel.bottomAnchor.constraint(equalTo: centerYAnchor),

            settingsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: m * 30),
            settingsButton.heightAnchor.constraint(equalToConstant: m * 6),
            settingsButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: m * 5),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }
}

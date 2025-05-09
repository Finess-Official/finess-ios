//
//  MainViewButton.swift
//  finess
//
//  Created by Elina Karapetyan on 20.04.2025.
//

import UIKit

class MainViewButton: UIButton {

    private var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        return stackView
    }()

    private var iconView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.mainViewButtonInnerViewCornerRadius
        view.clipsToBounds = true
        view.backgroundColor = Constants.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Constants.normalButtonColor
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    private var buttonTitle: UILabel = {
        let label = UILabel()
        label.font = Constants.smallButtonFont
        label.isUserInteractionEnabled = false
        return label
    }()

    init(title: String, image: UIImage?) {
        super.init(frame: .zero)
        isUserInteractionEnabled = true 

        buttonTitle.text = title
        iconImageView.image = image
        backgroundColor = Constants.mainViewButtonBackgroundColor
        layer.cornerRadius = Constants.mainViewButtonCornerRadius

        addSubview(contentStackView)
        contentStackView.addArrangedSubview(iconView)
        contentStackView.addArrangedSubview(buttonTitle)
        iconView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            iconView.heightAnchor.constraint(equalToConstant: Constants.mainViewButtonInnerViewSize),
            iconView.widthAnchor.constraint(equalToConstant: Constants.mainViewButtonInnerViewSize),

            iconImageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

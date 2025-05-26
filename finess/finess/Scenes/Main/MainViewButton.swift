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
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        return stackView
    }()

    var iconView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .tinkoffYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .tinkoffBlack
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    private var buttonTitle: UILabel = {
        let label = UILabel()
        label.font = .tinkoffHeading()
        label.textColor = .tinkoffBlack
        label.isUserInteractionEnabled = false
        return label
    }()

    init(title: String, image: UIImage?) {
        super.init(frame: .zero)
        isUserInteractionEnabled = true 

        buttonTitle.text = title
        iconImageView.image = image
        backgroundColor = .white
        layer.cornerRadius = 20
        
        // Добавляем тень
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.1
        
        // Добавляем border
        layer.borderWidth = 1
        layer.borderColor = UIColor.tinkoffBlack.withAlphaComponent(0.1).cgColor

        addSubview(contentStackView)
        contentStackView.addArrangedSubview(iconView)
        contentStackView.addArrangedSubview(buttonTitle)
        iconView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -16),

            iconView.heightAnchor.constraint(equalToConstant: 40),
            iconView.widthAnchor.constraint(equalToConstant: 40),

            iconImageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateDown()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateUp()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateUp()
    }
    
    private func animateDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func animateUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
}

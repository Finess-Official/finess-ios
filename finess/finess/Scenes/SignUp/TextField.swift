//
//  TextField.swift
//  finess
//
//  Created by Elina Karapetyan on 30.03.2025.
//


import UIKit

final class RegisterTextField: UITextField {

    private enum ButtonImage: String {
        case eye = "eye"
        case eyeFill = "eye.slash"
    }

    private var currentButtonState: ButtonImage = .eye

    // MARK: - Private property
    private let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 40)

    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: ButtonImage.eye.rawValue), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            switch currentButtonState {
            case .eye:
                currentButtonState = .eyeFill
                button.setImage(UIImage(systemName: ButtonImage.eyeFill.rawValue), for: .normal)
                isSecureTextEntry = true
            case .eyeFill:
                currentButtonState = .eye
                button.setImage(UIImage(systemName: ButtonImage.eye.rawValue), for: .normal)
                isSecureTextEntry = false
            }
        }), for: .touchUpInside)
        return button
    }()

    init(placeholder: String) {
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    // MARK: - Private Methods
    private func setupTextField(placeholder: String) {
        textColor = .black
        layer.cornerRadius = 16
        layer.backgroundColor = UIColor.systemGray6.cgColor
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])

        addSubview(rightButton)

        heightAnchor.constraint(equalToConstant: 56).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

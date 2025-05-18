//
//  TextField.swift
//  finess
//
//  Created by Elina Karapetyan on 30.03.2025.
//


import UIKit

final class RegisterTextField: UITextField {

    //MARK: - Internal Properties
    enum Mode {
        case required
        case secure
    }

    var isInErrorState: Bool = false {
        didSet {
            layer.borderColor = isInErrorState ? Constants.errorColor.cgColor : UIColor.tinkoffBlack.withAlphaComponent(0.1).cgColor
            layer.borderWidth = 1
        }
    }

    public let padding = Constants.textFieldPadding

    // MARK: - Private property
    private enum ButtonImage: String {
        case eye = "eye"
        case eyeFill = "eye.slash"
    }

    private var currentButtonState: ButtonImage? {
        didSet {
            switch currentButtonState {
            case .eye:
                rightButton.setImage(UIImage(systemName: ButtonImage.eyeFill.rawValue), for: .normal)
                rightButton.tintColor = Constants.normalButtonColor
                isSecureTextEntry = false
            case .eyeFill:
                rightButton.setImage(UIImage(systemName: ButtonImage.eye.rawValue), for: .normal)
                rightButton.tintColor = Constants.normalButtonColor
                isSecureTextEntry = true
            case .none:
                break
            }
        }
    }

    private var currentMode: Mode

    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            switch currentButtonState {
            case .eye:
                currentButtonState = .eyeFill
                isSecureTextEntry = true
            case .eyeFill:
                currentButtonState = .eye
                isSecureTextEntry = false
            case .none:
                break
            }
        }), for: .touchUpInside)
        return button
    }()

    init(placeholder: String, mode: Mode) {
        self.currentMode = mode
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
        textColor = Constants.textColor
        layer.cornerRadius = Constants.textFieldCornerRadius
        layer.backgroundColor = UIColor.systemGray6.cgColor
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])

        if currentMode == .secure {
            addSubview(rightButton)
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding).isActive = true
            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            currentButtonState = .eye
        }
    }
}

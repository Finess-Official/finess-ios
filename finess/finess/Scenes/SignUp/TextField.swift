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
            currentButtonState = isInErrorState ? .exclamationmark : .eye
            isSecureTextEntry = false
        }
    }

    public let padding = Constants.textFieldPadding

    // MARK: - Private property
    private enum ButtonImage: String {
        case eye = "eye"
        case eyeFill = "eye.slash"
        case exclamationmark = "exclamationmark.triangle"
        case asterisk = "asterisk"
    }

    private var currentButtonState: ButtonImage? {
        didSet {
            rightButton.tintColor = isInErrorState ? Constants.errorColor: Constants.normalButtonColor
            switch currentButtonState {
            case .eye:
                rightButton.setImage(UIImage(systemName: ButtonImage.eyeFill.rawValue), for: .normal)
            case .eyeFill:
                rightButton.setImage(UIImage(systemName: ButtonImage.eye.rawValue), for: .normal)
            case .asterisk:
                rightButton.setImage(UIImage(systemName: ButtonImage.asterisk.rawValue), for: .normal)
                rightButton.tintColor = Constants.errorColor
            case .exclamationmark:
                rightButton.setImage(UIImage(systemName: isInErrorState ? ButtonImage.exclamationmark.rawValue: ButtonImage.eye.rawValue), for: .normal)
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
                button.setImage(UIImage(systemName: ButtonImage.eyeFill.rawValue), for: .normal)
                isSecureTextEntry = true
            case .eyeFill:
                currentButtonState = .eye
                button.setImage(UIImage(systemName: ButtonImage.eye.rawValue), for: .normal)
                isSecureTextEntry = false
            case .exclamationmark, .asterisk, .none:
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

        addSubview(rightButton)

        heightAnchor.constraint(equalToConstant: Constants.textFieldHeight).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        switch currentMode {
        case .required:
            currentButtonState = .asterisk
        case .secure:
            currentButtonState = .eye
        }
    }
}

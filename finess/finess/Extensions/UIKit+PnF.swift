import UIKit

// MARK: - Colors
extension UIColor {
    // Основные цвета
    static let tinkoffYellow = UIColor(red: 255/255, green: 221/255, blue: 45/255, alpha: 1.0)    // FFDD2D
    static let tinkoffBlack = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)       // #222222
    static let tinkoffWhite = UIColor.white
    static let tinkoffGray = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)     // #999999
    static let tinkoffBackground = UIColor.white
    
    // Дополнительные цвета
    static let tinkoffRed = UIColor(red: 239/255, green: 58/255, blue: 71/255, alpha: 1.0)        // #EF3A47
    static let tinkoffGreen = UIColor(red: 79/255, green: 176/255, blue: 80/255, alpha: 1.0)      // #4FB050
}

// MARK: - Fonts
extension UIFont {
    static func tinkoffTitle1() -> UIFont {
        return UIFont.systemFont(ofSize: 28, weight: .bold)
    }
    
    static func tinkoffTitle2() -> UIFont {
        return UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    static func tinkoffHeading() -> UIFont {
        return UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    static func tinkoffBody() -> UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    static func tinkoffCaption() -> UIFont {
        return UIFont.systemFont(ofSize: 13, weight: .regular)
    }
}

// MARK: - Button Styles
extension UIButton {
    func applyTinkoffStyle(style: TinkoffButtonStyle = .primary) {
        layer.cornerRadius = 8
        titleLabel?.font = .tinkoffHeading()
        
        switch style {
        case .primary:
            backgroundColor = .tinkoffYellow
            setTitleColor(.tinkoffBlack, for: .normal)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 4
            layer.shadowOpacity = 0.08
        case .secondary:
            backgroundColor = .clear
            setTitleColor(.tinkoffYellow, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = UIColor.tinkoffYellow.cgColor
        }
        
        // Добавляем обработчики нажатий для анимации
        addTarget(self, action: #selector(animateDown), for: .touchDown)
        addTarget(self, action: #selector(animateUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    enum TinkoffButtonStyle {
        case primary
        case secondary
    }
    
    @objc private func animateDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
    }
    
    @objc private func animateUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
}

// MARK: - TextField Styles
extension UITextField {
    func applyTinkoffStyle() {
        backgroundColor = .tinkoffBackground
        textColor = .tinkoffBlack
        font = .tinkoffBody()
        layer.cornerRadius = 8
        
        // Отступы для текста
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
        
        // Плейсхолдер
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.tinkoffGray]
        )
    }
}

// MARK: - Navigation Bar Appearance
extension UINavigationBar {
    func applyTinkoffStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tinkoffWhite
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.tinkoffBlack,
            .font: UIFont.tinkoffHeading()
        ]
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.08)
        
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
        
        tintColor = .tinkoffYellow
    }
}

// MARK: - View Extensions
extension UIView {
    func addTinkoffShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.08
    }
}
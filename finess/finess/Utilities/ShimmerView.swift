import UIKit

class ShimmerView: UIView {
    private let gradientLayer = CAGradientLayer()
    private var animationKey = "shimmerAnimation"
    private var isShimmering = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        gradientLayer.colors = [
            UIColor(white: 0.92, alpha: 1).cgColor,
            UIColor(white: 1.0, alpha: 1).cgColor,
            UIColor(white: 1.0, alpha: 1).cgColor,
            UIColor(white: 0.92, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0, 0.3, 0.35, 1]
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = bounds.height / 2
        if isShimmering && gradientLayer.animation(forKey: animationKey) == nil {
            startShimmering()
        }
    }

    func startShimmering() {
        isShimmering = true
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.2, 0.2, 1]
        animation.toValue = [0, 0.25, 1.25, 2]
        animation.duration = 2
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        gradientLayer.add(animation, forKey: animationKey)
    }

    func stopShimmering() {
        isShimmering = false
        gradientLayer.removeAnimation(forKey: animationKey)
    }
}


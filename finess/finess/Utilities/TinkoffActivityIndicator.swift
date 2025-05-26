import UIKit

class TinkoffActivityIndicator: UIView {
    private let shapeLayer = CAShapeLayer()
    private var isSetup = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { super.init(coder: coder); setup() }

    private func setup() {
        guard !isSetup else { return }
        isSetup = true
        let lineWidth: CGFloat = 4
        let radius: CGFloat = 18
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: .pi * 3 / 2,
            clockwise: true
        )
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red: 1, green: 0.82, blue: 0.09, alpha: 1).cgColor // Tinkoff Yellow
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0.75
        layer.addSublayer(shapeLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        let lineWidth: CGFloat = 4
        let radius: CGFloat = min(bounds.width, bounds.height) / 2 - lineWidth / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: .pi * 3 / 2,
            clockwise: true
        )
        shapeLayer.path = circularPath.cgPath
    }

    func startAnimating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1
        rotation.repeatCount = .infinity
        layer.add(rotation, forKey: "rotation")
    }

    func stopAnimating() {
        layer.removeAnimation(forKey: "rotation")
    }
} 
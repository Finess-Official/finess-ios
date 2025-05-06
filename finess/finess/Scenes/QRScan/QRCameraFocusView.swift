//
//  QRCameraFocusView.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import UIKit

public final class QRCameraFocusView: UIView {

    private let dimmingLayer = CALayer()
    private let maskLayer = CAShapeLayer()
    private let frameLayer = CAShapeLayer()

    private var previewTopConstraint: NSLayoutConstraint?
    private var previewCenterXConstraint: NSLayoutConstraint?

    init() {
        super.init(frame: .zero)

        let fogColor = UIColor(rgbHex: 0x1F2021).withAlphaComponent(0.6)
        dimmingLayer.backgroundColor = fogColor.cgColor
        dimmingLayer.frame = bounds

        layer.addSublayer(dimmingLayer)

        maskLayer.fillRule = .evenOdd

        dimmingLayer.mask = maskLayer

        layer.addSublayer(frameLayer)

        frameLayer.strokeColor = UIColor.white.cgColor
        frameLayer.lineWidth = 8
        frameLayer.fillColor = nil
        frameLayer.lineCap = .round

        updateFocusFrame()
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }

    public var objectFrame: CGRect? {
        didSet {
            updateFocusFrame(animated: true)

            if let frame = objectFrame {
                previewTopConstraint?.constant = frame.maxY + 24
                previewCenterXConstraint?.constant = frame.midX

                UIView.animate(
                    withDuration: 0.4,
                    delay: 0,
                    options: [.allowUserInteraction, .curveEaseInOut]
                ) {
                    self.layoutIfNeeded()
                }
            }
        }
    }

    private func detachPreview(_ view: UIView, completion: (() -> Void)? = nil) {
        var transform = CGAffineTransform.identity

        transform = transform.scaledBy(x: 0.001, y: 0.001)
        transform = transform.concatenating(
            CGAffineTransform(
                translationX: 0,
                y: -view.intrinsicContentSize.height / 2
            )
        )

        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            animations: {
                view.transform = transform
                view.alpha = 0
            },
            completion: { _ in
                view.removeFromSuperview()
                completion?()
            }
        )
    }

    private func attachPreview(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        let topConstraint = view.topAnchor.constraint(
            equalTo: topAnchor,
            constant: (objectFrame?.maxY ?? 0) + frameLayer.lineWidth
        )
        let centerXConstraint = view.centerXAnchor.constraint(
            equalTo: leadingAnchor,
            constant: objectFrame?.midX ?? 0
        )

        view.layer.cornerRadius = 24
        view.alpha = 0

        previewTopConstraint = topConstraint
        previewCenterXConstraint = centerXConstraint

        NSLayoutConstraint.activate([
            topConstraint,
            centerXConstraint,
        ])

        var transform = CGAffineTransform.identity

        transform = transform.scaledBy(x: 0.001, y: 0.001)
        transform = transform.concatenating(
            CGAffineTransform(
                translationX: 0,
                y: -view.intrinsicContentSize.height / 2
            )
        )

        view.transform = transform

        UIView.animate(withDuration: 0.3) {
            view.transform = .identity
            view.alpha = 1
        }
    }

    private func updateFocusFrame(animated: Bool = false) {
        let intialEdge = bounds.width * 0.45
        let heightDivider = 2.5
        let focusFrame =
            objectFrame
            ?? CGRect(
                x: bounds.width / 2 - intialEdge / 2,
                y: bounds.height / heightDivider - intialEdge / 2,
                width: intialEdge,
                height: intialEdge
            )

        let radius = focusFrame.width * 0.15

        let maskPath = UIBezierPath()
        maskPath.append(UIBezierPath(rect: bounds))
        maskPath.append(UIBezierPath(roundedRect: focusFrame, cornerRadius: radius))

        let focusPath = frameFocusPath(focusFrame: focusFrame, radius: radius).cgPath

        if animated {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.1)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
            if let fromMaskPath = maskLayer.presentation()?.path {
                let maskAnimation = pathAnimation(from: fromMaskPath, to: maskPath.cgPath)
                maskLayer.add(maskAnimation, forKey: "mask")
            }

            if let fromFocusPath = frameLayer.presentation()?.path {
                let focusFrameAnimation = pathAnimation(from: fromFocusPath, to: focusPath)
                frameLayer.add(focusFrameAnimation, forKey: "focus")
            }
            CATransaction.commit()
        }

        maskLayer.path = maskPath.cgPath
        frameLayer.path = focusPath
    }

    private func frameFocusPath(focusFrame: CGRect, radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let w = focusFrame.width
        let h = focusFrame.height

        let r = radius
        let l = max((w - w * 0.4 - r * 2) / 2, 0)
        path.move(to: CGPoint(x: 0, y: r + l))
        path.addLine(to: CGPoint(x: 0, y: r))
        path.addQuadCurve(to: CGPoint(x: r, y: 0), controlPoint: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: r + l, y: 0))

        path.move(to: CGPoint(x: w - r - l, y: 0))
        path.addLine(to: CGPoint(x: w - r, y: 0))
        path.addQuadCurve(to: CGPoint(x: w, y: r), controlPoint: CGPoint(x: w, y: 0))
        path.addLine(to: CGPoint(x: w, y: r + l))

        path.move(to: CGPoint(x: w, y: h - r - l))
        path.addLine(to: CGPoint(x: w, y: h - r))
        path.addQuadCurve(to: CGPoint(x: w - r, y: h), controlPoint: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: w - r - l, y: h))

        path.move(to: CGPoint(x: r + l, y: h))
        path.addLine(to: CGPoint(x: r, y: h))
        path.addQuadCurve(to: CGPoint(x: 0, y: h - r), controlPoint: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: 0, y: h - r - l))

        path.apply(.init(translationX: focusFrame.minX, y: focusFrame.minY))

        return path
    }

    private func pathAnimation(from: CGPath, to: CGPath) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = from
        animation.toValue = to
        return animation
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        dimmingLayer.frame = bounds
        frameLayer.frame = bounds

        updateFocusFrame()
    }

}

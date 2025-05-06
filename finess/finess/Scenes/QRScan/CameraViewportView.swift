//
//  CameraViewportView.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import UIKit

final class CameraViewportView: UIView {
    private let noCameraAccessView: NoCameraAccessView

    var didTapOpenSettingsButton: (() -> Void)? {
        set { noCameraAccessView.didTapOpenSettingsButton = newValue }
        get { noCameraAccessView.didTapOpenSettingsButton }
    }

    init() {
        self.noCameraAccessView = NoCameraAccessView()

        super.init(frame: .zero)

        backgroundColor = .black

        addSubview(noCameraAccessView)
        noCameraAccessView.translatesAutoresizingMaskIntoConstraints = false
        noCameraAccessView.isHidden = true

        let constraints = [
            noCameraAccessView.leadingAnchor.constraint(equalTo: leadingAnchor),
            noCameraAccessView.trailingAnchor.constraint(equalTo: trailingAnchor),
            noCameraAccessView.topAnchor.constraint(equalTo: topAnchor),
            noCameraAccessView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    var previewView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            guard let view = previewView else { return }
            noCameraAccessView.isHidden = true

            view.alpha = 0
            UIView.animate(withDuration: 0.3) {
                view.alpha = 1
            }

            insertSubview(view, belowSubview: noCameraAccessView)
            view.translatesAutoresizingMaskIntoConstraints = false

            let constraints = [
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.topAnchor.constraint(equalTo: topAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
            NSLayoutConstraint.activate(constraints)
        }
    }

    var isNoCameraAccessViewHidden: Bool = true {
        didSet {
            noCameraAccessView.isHidden = isNoCameraAccessViewHidden
            previewView?.isHidden = !isNoCameraAccessViewHidden
            bringSubviewToFront(noCameraAccessView)
        }
    }
}

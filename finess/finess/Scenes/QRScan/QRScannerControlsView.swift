//
//  QRScannerControlsView.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import UIKit

final class QRScannerControlsView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.accessibilityTraits = .header
        return label
    }()

    let focusView = QRCameraFocusView()

    var title: NSAttributedString? {
        didSet {
            titleLabel.attributedText = title
            titleLabel.accessibilityLabel = NSLocalizedString(title?.string ?? "", comment: "")
        }
    }

    init() {
        super.init(frame: .zero)

        let m = 8.0
        let horizontalMargin = 20 * 4.5

        [focusView, titleLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let constraints = [
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -m
            ),
            titleLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: leadingAnchor,
                constant: m
            ),

            focusView.leadingAnchor.constraint(equalTo: leadingAnchor),
            focusView.topAnchor.constraint(equalTo: topAnchor),
            focusView.trailingAnchor.constraint(equalTo: trailingAnchor),
            focusView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  LoadingManager.swift
//  finess
//
//  Created by Elina Karapetyan on 12.04.2025.
//

import UIKit

class LoadingView: UIView {

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    func configure() {
        backgroundColor = .white

        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func start() {
        activityIndicator.startAnimating()
    }

    func stop(completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.activityIndicator.stopAnimating()
            completion?()
        }
    }
}

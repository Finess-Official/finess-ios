//
//  LoadingManager.swift
//  finess
//
//  Created by Elina Karapetyan on 12.04.2025.
//

import UIKit

class LoadingView: UIView {
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let indicator: TinkoffActivityIndicator = {
        let indicator = TinkoffActivityIndicator()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.08)
        addSubview(container)
        container.addSubview(indicator)

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 88),
            container.heightAnchor.constraint(equalToConstant: 88),

            indicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 44),
            indicator.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure() {}

    func start() {
        indicator.startAnimating()
    }

    func stop(completion: (() -> Void)? = nil) {
        indicator.stopAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            completion?()
        }
    }
}

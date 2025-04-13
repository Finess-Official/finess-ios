//
//  LoadingManager.swift
//  finess
//
//  Created by Elina Karapetyan on 12.04.2025.
//

import UIKit

class LoadingManager {
    static let shared = LoadingManager()
    private let loadingViewController = LoadingViewController()

    func showLoading(in navigationController: UINavigationController?, completion: (() -> Void)? = nil) {
        navigationController?.pushViewController(loadingViewController, animated: false)
        loadingViewController.start()
        completion?()
    }

    func hideLoading(from navigationController: UINavigationController?, completion: (() -> Void)? = nil) {
        loadingViewController.stop {
            navigationController?.popViewController(animated: false)
            completion?()
        }
    }
}

class LoadingViewController: UIViewController {

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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

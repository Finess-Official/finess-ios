//
//  AppCoordinator.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import SwiftUI
import Combine

class AuthCoordinator {
    private var subscriptions = Set<AnyCancellable>()

    private let hasLoggedIn = Auth.shared.loggedIn
    private let window: UIWindow
    private let signUpViewController: SignUpViewController
    private let signInViewController: SignInViewController
    private let tabBarController: TabBarController

    private let navigationController: UINavigationController?

    init(window: UIWindow, navigationController: UINavigationController?, tabBarController: TabBarController) {
        self.window = window
        self.navigationController = navigationController

        self.signUpViewController = SignUpViewController()
        self.signInViewController = SignInViewController(userDidSignedUp: Auth.shared.isSignedUp)
        self.tabBarController = tabBarController

        self.signUpViewController.delegate = self
        self.signInViewController.delegate = self
    }

    func start() {
        hasLoggedIn
            .removeDuplicates()
            .sink { [weak self] hasLoggedIn in
                DispatchQueue.main.async {
                    self?.navigateToScreen(hasLoggedIn: hasLoggedIn)
                }
            }
            .store(in: &subscriptions)
    }

    private func navigateToScreen(hasLoggedIn: Bool) {
        if hasLoggedIn {
            navigationController?.setViewControllers([tabBarController], animated: false)
        } else {
            navigationController?.setViewControllers([signInViewController], animated: false)
        }
    }
}

// MARK: - SignUpViewControllerDelegate

extension AuthCoordinator: SignUpViewControllerDelegate {
    func didTapSignIn() {
        navigationController?.setViewControllers([signInViewController], animated: false)
    }
}

// MARK: - SignInViewControllerDelegate

extension AuthCoordinator: SignInViewControllerDelegate {
    func didTapSignUpButton() {
        navigationController?.setViewControllers([signUpViewController], animated: false)
    }
}

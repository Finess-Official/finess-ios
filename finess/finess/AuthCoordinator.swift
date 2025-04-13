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
    private let authError = Auth.shared.authError

    private var isStart = true
    private let window: UIWindow
    private let signUpViewController: SignUpViewController
    private let signInViewController: SignInViewController
    private let mainViewController: MainViewController

    private let navigationController: UINavigationController?

    init(window: UIWindow, navigationController: UINavigationController?, mainViewController: MainViewController) {
        self.window = window
        self.navigationController = navigationController

        self.signUpViewController = SignUpViewController()
        self.signInViewController = SignInViewController(userDidSignedUp: Auth.shared.isSignedUp)
        self.mainViewController = mainViewController

        self.signUpViewController.delegate = self
        self.signInViewController.delegate = self
    }

    func start() {
        hasLoggedIn
            .removeDuplicates()
            .sink { [weak self] hasLoggedIn in
                DispatchQueue.main.async {
                    self?.handleNavigation(hasLoggedIn: hasLoggedIn)
                }
            }
            .store(in: &subscriptions)

        authError
            .sink { [weak self] error in
                DispatchQueue.main.async {
                    self?.handleAuthError(error)
                }
            }
            .store(in: &subscriptions)
    }

    private func handleNavigation(hasLoggedIn: Bool) {
        if isStart {
            navigateToScreen(hasLoggedIn: hasLoggedIn)
            isStart = false
        } else {
            updateLoading(isLoading: false) { [weak self] in
                self?.navigateToScreen(hasLoggedIn: hasLoggedIn)
            }
        }
    }

    private func navigateToScreen(hasLoggedIn: Bool) {
        if hasLoggedIn {
            navigationController?.setViewControllers([mainViewController], animated: false)
        } else {
            navigationController?.setViewControllers([signInViewController], animated: false)
        }
    }

    private func handleAuthError(_ error: APIErrorHandler?) {
        guard let error = error else { return }
        updateLoading(isLoading: false) {
            ErrorHandler.shared.showError(error, navigationController: self.navigationController)
        }
    }

    private func updateLoading(isLoading: Bool, completion: (() -> Void)? = nil) {
        if isLoading {
            LoadingManager.shared.showLoading(in: navigationController, completion: completion)
        } else {
            LoadingManager.shared.hideLoading(from: navigationController, completion: completion)
        }
    }
}

// MARK: - SignUpViewControllerDelegate

extension AuthCoordinator: SignUpViewControllerDelegate {
    func didTapSignIn() {
        navigationController?.setViewControllers([signInViewController], animated: false)
    }

    func didTapSignUp(with password: String?) {
        guard let password = password else { return }
        updateLoading(isLoading: true)
        Auth.shared.signUp(password: password)
    }
}

// MARK: - SignInViewControllerDelegate

extension AuthCoordinator: SignInViewControllerDelegate {
    func didTapSignInButton(with password: String?) {
        guard let password = password else { return }
        updateLoading(isLoading: true)
        Auth.shared.signIn(password: password)
    }

    func didTapSignUpButton() {
        navigationController?.setViewControllers([signUpViewController], animated: false)
    }
}

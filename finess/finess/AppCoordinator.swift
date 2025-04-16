//
//  AppCoordinator.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import SwiftUI
import Combine

class AppCoordinator {

    var subscriptions = Set<AnyCancellable>()

    let hasLoggedIn = Auth.shared.loggedIn
    let signUpViewController = SignUpViewController()
    let signinViewController = SignInViewController()
    let navigationController: UINavigationController?
    let window: UIWindow

    init(window: UIWindow, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
        self.signUpViewController.delegate = self
        self.signinViewController.delegate = self
        navigationController?.navigationBar.isHidden = true
    }

    func start() {
        hasLoggedIn
            .removeDuplicates()
            .sink { [weak self] hasLoggedIn in
                guard let self else { return }
                if hasLoggedIn {
                    DispatchQueue.main.async {
                    }
                } else {
                    navigationController?.setViewControllers([self.signinViewController], animated: true)
                    self.window.rootViewController = navigationController
                }
            }
            .store(in: &subscriptions)
    }
}

extension AppCoordinator: SignUpViewControllerDelegate {
    func didTapSignIn() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapSignUp() {}
}

extension AppCoordinator: SignInViewControllerDelegate {
    func didTapSignInButton(with password: String?) {}
    
    func didTapSignUpButton() {
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
}

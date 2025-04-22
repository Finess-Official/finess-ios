//
//  AppCoordinator.swift
//  finess
//
//  Created by Elina Karapetyan on 12.04.2025.
//

import Combine
import UIKit

class AppCoordinator {
    private var subscriptions = Set<AnyCancellable>()
    
    private let window: UIWindow
    private let navigationController: UINavigationController?
    private let mainViewController: MainViewController
    private var authCoordinator: AuthCoordinator?

    init(window: UIWindow, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isHidden = true
        self.mainViewController = MainViewController()
        mainViewController.delegate = self
    }

    func start() {
        self.window.rootViewController = self.navigationController
        self.authCoordinator = AuthCoordinator(window: window, navigationController: navigationController, mainViewController: mainViewController)
        self.authCoordinator?.start()
    }
}

extension AppCoordinator: MainViewControllerDelegate {
    func didTapLogout() {
        Auth.shared.logout()
    }
}

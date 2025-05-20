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
    private let tabBarController: TabBarController
    private var authCoordinator: AuthCoordinator?

    init(window: UIWindow, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isHidden = true
        let tabBarController = TabBarController()
        self.tabBarController = tabBarController
    }

    func start() {
        self.window.rootViewController = self.navigationController
        self.authCoordinator = AuthCoordinator(window: window, navigationController: navigationController, tabBarController: tabBarController)
        self.authCoordinator?.start()
    }
    
    private func returnToMainScreen() {
        tabBarController.selectedIndex = Tabs.qr.rawValue
        if let navController = tabBarController.selectedViewController as? UINavigationController {
            navController.popToRootViewController(animated: true)
            navController.dismiss(animated: true)
        }
    }
}

// MARK: - DeepLinkHandlerDelegate
extension AppCoordinator: DeepLinkHandlerDelegate {
    func handle(deepLinkType: DeepLinkType) {
        switch deepLinkType {
        case .mainScreen:
            if Auth.shared.isSignedUp {
                navigationController?.setViewControllers([tabBarController], animated: true)
                returnToMainScreen()
            } else {
                authCoordinator?.showSignIn()
            }
        case .tkassa:
            if Auth.shared.isSignedUp {
                navigationController?.setViewControllers([tabBarController], animated: true)
                returnToMainScreen()
            } else {
                authCoordinator?.showSignIn()
            }
        case .unknown:
            break
        }
    }
}

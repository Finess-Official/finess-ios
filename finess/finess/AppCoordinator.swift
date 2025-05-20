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
    
    private func showSuccessNotification() {
        print("Showing success notification")
        
        let notificationView = UIView()
        notificationView.backgroundColor = .white
        notificationView.layer.cornerRadius = 24
        notificationView.layer.masksToBounds = false
        notificationView.layer.shadowColor = UIColor.black.cgColor
        notificationView.layer.shadowOpacity = 0.08
        notificationView.layer.shadowOffset = CGSize(width: 0, height: 4)
        notificationView.layer.shadowRadius = 16
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        
        // Green circle with checkmark
        let iconContainer = UIView()
        iconContainer.backgroundColor = UIColor(red: 0.22, green: 0.78, blue: 0.36, alpha: 1) // #38C35C
        iconContainer.layer.cornerRadius = 18
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let checkmark = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        checkmark.image = UIImage(systemName: "checkmark", withConfiguration: config)
        checkmark.tintColor = .white
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        
        iconContainer.addSubview(checkmark)
        
        let label = UILabel()
        label.text = "Баланс пополнен"
        label.textColor = .tinkoffBlack
        label.font = .tinkoffBody()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        notificationView.addSubview(iconContainer)
        notificationView.addSubview(label)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("Failed to get window")
            return
        }
        
        window.addSubview(notificationView)
        
        NSLayoutConstraint.activate([
            notificationView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 16),
            notificationView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -16),
            notificationView.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 16),
            notificationView.heightAnchor.constraint(equalToConstant: 56),

            iconContainer.leadingAnchor.constraint(equalTo: notificationView.leadingAnchor, constant: 16),
            iconContainer.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 36),
            iconContainer.heightAnchor.constraint(equalToConstant: 36),

            checkmark.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),

            label.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor, constant: -16)
        ])
        
        // Анимация появления
        notificationView.alpha = 0
        notificationView.transform = CGAffineTransform(translationX: 0, y: -20)
        
        UIView.animate(withDuration: 0.3, animations: {
            notificationView.alpha = 1
            notificationView.transform = .identity
        }) { _ in
            // Анимация исчезновения через 2 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.3, animations: {
                    notificationView.alpha = 0
                    notificationView.transform = CGAffineTransform(translationX: 0, y: -20)
                }) { _ in
                    notificationView.removeFromSuperview()
                }
            }
        }
    }
}

// MARK: - DeepLinkHandlerDelegate
extension AppCoordinator: DeepLinkHandlerDelegate {
    func handle(deepLinkType: DeepLinkType) {
        print("Handling deep link type: \(deepLinkType)")
        switch deepLinkType {
        case .mainScreen:
            if Auth.shared.isSignedUp {
                print("User is signed up, showing main screen")
                navigationController?.setViewControllers([tabBarController], animated: true)
                returnToMainScreen()
            } else {
                print("User is not signed up, showing sign in")
                authCoordinator?.showSignIn()
            }
        case .tkassa:
            if Auth.shared.isSignedUp {
                navigationController?.setViewControllers([tabBarController], animated: true)
                returnToMainScreen()
                showSuccessNotification()
            } else {
                authCoordinator?.showSignIn()
            }
        case .unknown:
            print("Unknown deep link type")
            break
        }
    }
}

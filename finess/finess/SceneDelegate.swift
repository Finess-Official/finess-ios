//
//  SceneDelegate.swift
//  finess
//
//  Created by Elina Karapetyan on 27.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var appCoordinator: AppCoordinator?
    var navigationController: UINavigationController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = (scene as? UIWindowScene) {
            let window = UIWindow(windowScene: windowScene)
            navigationController = UINavigationController()
            let appCoordinator = AppCoordinator(window: window, navigationController: navigationController)
            appCoordinator.start()
            self.appCoordinator = appCoordinator
            window.makeKeyAndVisible()
        }
    }
}


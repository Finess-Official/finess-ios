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
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        startApplication()

        if let url = connectionOptions.urlContexts.first?.url {
            handleDeepLink(url)
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleDeepLink(url)
    }

    private func startApplication() {
        guard let window = window else { return }
        navigationController = UINavigationController()
        let appCoordinator = AppCoordinator(window: window, navigationController: navigationController)
        appCoordinator.start()
        self.appCoordinator = appCoordinator
    }

    private func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else { return }

        let type: DeepLinkType

        switch host {
        case "main_screen":
            type = .mainScreen
        case "tkassa":
            type = .tkassa
        default:
            type = .unknown
        }

        appCoordinator?.handle(deepLinkType: type)
    }

    private func canHandle(_ url: URL) -> Bool {
        return url.scheme == "finesspay"
    }
}


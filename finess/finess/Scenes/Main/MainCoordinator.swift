//
//  MainCoordinator.swift
//  finess
//
//  Created by Elina Karapetyan on 27.04.2025.
//

import UIKit

class MainCoordinator {
    private let mainViewController = MainViewController()
    private let createQRViewController = CreateQRViewController()
    private var mainNavigationController = UINavigationController()

    init() {
        mainViewController.delegate = self
    }

    func start() -> UINavigationController {
        mainNavigationController = UINavigationController(rootViewController: mainViewController)
        mainViewController.tabBarItem = UITabBarItem(title: Constants.qrIconTitle, image: Constants.qrIcon, tag: Tabs.qr.rawValue)
        return mainNavigationController
    }
}

extension MainCoordinator: MainViewControllerDelegate {
    func didTapCreateQRCodeButton() {
        mainNavigationController.navigationBar.tintColor = .black
        mainNavigationController.pushViewController(createQRViewController, animated: true)
    }
}

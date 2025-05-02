//
//  MainCoordinator.swift
//  finess
//
//  Created by Elina Karapetyan on 27.04.2025.
//

import UIKit

class MainCoordinator {
    private let mainViewController = MainViewController()
    private let addAccountViewController = AddAccountViewController()
    private let createQRViewController = CreateQRViewController()
    private var mainNavigationController = UINavigationController()

    init() {
        mainViewController.delegate = self
        addAccountViewController.delegate = self
    }

    func start() -> UINavigationController {
        mainNavigationController = UINavigationController(rootViewController: mainViewController)
        mainViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("QRTitle", comment: ""), image: Constants.qrIcon, tag: Tabs.qr.rawValue)
        mainNavigationController.navigationBar.tintColor = .black
        return mainNavigationController
    }
}

extension MainCoordinator: MainViewControllerDelegate {
    func didTapCreateQRCodeButton() {
        mainNavigationController.pushViewController(addAccountViewController, animated: true)
    }
}

extension MainCoordinator: AddAccountViewControllerDelegate {
    func accountDidCreated() {
        mainNavigationController.pushViewController(createQRViewController, animated: true)
    }
}

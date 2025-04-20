//
//  TabBarController.swift
//  finess
//
//  Created by Elina Karapetyan on 20.04.2025.
//

import UIKit

enum Tabs: Int {
    case qr
}

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        tabBar.tintColor = Constants.tabBarActive
        tabBar.barTintColor = Constants.tabBarInactive
        tabBar.backgroundColor = Constants.backgroundColor

        tabBar.layer.borderColor = UIColor.gray.cgColor
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.masksToBounds = true

        let mainViewController = MainViewController()
        let mainNavigation = UINavigationController(rootViewController: mainViewController)
        mainNavigation.navigationBar.isHidden = true
        mainViewController.tabBarItem = UITabBarItem(title: Constants.qrIconTitle, image: Constants.qrIcon, tag: Tabs.qr.rawValue)

        setViewControllers([mainNavigation], animated: false)
    }

}

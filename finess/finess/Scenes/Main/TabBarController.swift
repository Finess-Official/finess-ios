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

    private let mainCoordinator = MainCoordinator()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        tabBar.tintColor = Constants.tabBarActive
        tabBar.barTintColor = Constants.tabBarInactive
        tabBar.backgroundColor = Constants.backgroundColor

        tabBar.layer.borderColor = Constants.tabBarBorderColor
        tabBar.layer.borderWidth = Constants.tabBarBorderWidth
        tabBar.layer.masksToBounds = true

        setViewControllers([mainCoordinator.start()], animated: false)
    }

}

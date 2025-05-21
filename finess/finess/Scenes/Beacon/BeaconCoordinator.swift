//
//  MainCoordinator.swift
//  finess
//
//  Created by Elina Karapetyan on 21.05.2025.
//

import UIKit

class BeaconCoordinator {
    private let beaconViewController = BeaconViewController()
    private var mainNavigationController: UINavigationController

    init() {
        self.mainNavigationController = UINavigationController(rootViewController: beaconViewController)

    }

    func start() -> UINavigationController {
        mainNavigationController.navigationBar.tintColor = .black
        return mainNavigationController
    }
}

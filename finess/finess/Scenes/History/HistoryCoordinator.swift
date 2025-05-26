//
//  HistoryCoordinator.swift
//  finess
//
//  Created by Elina Karapetyan on 26.05.2025.
//

import Foundation
import UIKit

class HistoryCoordinator {
    private let historyViewController = HistoryViewController()
    private let historyNavigationController: UINavigationController

    init() {
        self.historyNavigationController = UINavigationController(rootViewController: historyViewController)
    }

    func start() -> UINavigationController {
        historyNavigationController.navigationBar.tintColor = .black
        return historyNavigationController
    }
}

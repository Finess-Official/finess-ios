//
//  Coordinator.swift
//  finess
//
//  Created by Elina Karapetyan on 20.04.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start() -> UINavigationController
} 

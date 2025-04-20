//
//  UINavigationController.swift
//  finess
//
//  Created by Elina Karapetyan on 17.04.2025.
//

import UIKit

extension UINavigationController {
    @discardableResult
    @objc
    public func popViewController(animated: Bool, completion: (() -> Void)? = nil) -> UIViewController? {
        let result = popViewController(animated: animated)

        guard let coordinator = transitionCoordinator,
            let completionBlock = completion
        else {
            completion?()
            return result
        }
        coordinator.animate(alongsideTransition: nil) { _ in
            completionBlock()
        }

        return result
    }
}

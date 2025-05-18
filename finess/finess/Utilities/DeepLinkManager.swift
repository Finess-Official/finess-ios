//
//  DeepLinkManager.swift
//  finess
//
//  Created by Elina Karapetyan on 20.04.2025.
//

import UIKit

enum DeepLinkType {
    case mainScreen
    case unknown
}

protocol DeepLinkHandlerDelegate: AnyObject {
    func handle(deepLinkType: DeepLinkType)
}

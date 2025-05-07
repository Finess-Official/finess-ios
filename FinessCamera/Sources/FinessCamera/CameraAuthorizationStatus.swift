//
//  CameraAuthorizationStatus.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import Foundation

public enum CameraAuthorizationStatus {
    case notDetermined
    case denied
    case authorized
}

public protocol CameraAuthorizationStatusChecker {
    func check() -> CameraAuthorizationStatus
}

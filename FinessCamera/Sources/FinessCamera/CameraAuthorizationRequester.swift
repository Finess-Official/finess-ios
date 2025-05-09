//
//  CameraAuthorizationRequester.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import Foundation

public protocol CameraAuthorizationRequester {
    func requestCameraAuthorization(_ completion: @escaping @MainActor (CameraAuthorizationStatus) -> Void)
}

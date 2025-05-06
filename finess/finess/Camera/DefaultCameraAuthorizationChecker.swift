//
//  DefaultCameraAuthorizationChecker.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import AVFoundation

public final class DefaultCameraAuthorizationChecker {
    public init() {}
}

extension DefaultCameraAuthorizationChecker: CameraAuthorizationStatusChecker {
    public func check() -> CameraAuthorizationStatus {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            return .notDetermined
        case .restricted,
            .denied:
            return .denied
        case .authorized:
            return .authorized
        @unknown default:
            fatalError()
        }
    }
}

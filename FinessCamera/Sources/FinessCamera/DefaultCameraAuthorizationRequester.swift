//
//  DefaultCameraAuthorizationRequester.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import AVFoundation
import Foundation

public final class DefaultCameraAuthorizationRequester: CameraAuthorizationRequester {

    public init() {}
    
    public func requestCameraAuthorization(_ completion: @escaping @MainActor (CameraAuthorizationStatus) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    completion(.authorized)
                } else {
                    completion(.denied)
                }
            }
        }
    }
}

//
//  CameraCaptureSessionProvider.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import Foundation

public protocol CameraCaptureSessionProvider: Sendable {
    func preparedCaptureSession() throws -> CaptureSession
}

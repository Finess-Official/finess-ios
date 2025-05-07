//
//  CaptureSession.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import Foundation
import UIKit

@MainActor
public protocol CaptureSession: Sendable {
    var isRunning: Bool { get }
    var previewView: UIView { get }

    func startRunning()
    nonisolated func stopRunning()
}

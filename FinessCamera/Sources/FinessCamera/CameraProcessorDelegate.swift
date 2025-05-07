//
//  CameraProcessorDelegate.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import AVFoundation
import Foundation

@MainActor
public protocol CameraProcessorDelegate: AnyObject {
    func cameraProcessor(_: CameraProcessor, didObtain captureSession: CaptureSession)
    func cameraProcessorCapturingWasFailed(_: CameraProcessor)
    func cameraProcessorCapturingWasDenied(_: CameraProcessor)
}

@MainActor
public final class CameraProcessor {
    private enum State: Sendable {
        case initial
        case denied
        case authorizing
        case authorized
        case capturing(CaptureSession)
        case failed
        case stopped
    }

    let cameraAuthorizationStatusChecker: CameraAuthorizationStatusChecker
    let cameraAuthorizationRequester: CameraAuthorizationRequester
    nonisolated let cameraCaptureSessionProvider: CameraCaptureSessionProvider

    nonisolated(unsafe) private var notificationObservations = [Any]()

    public weak var delegate: CameraProcessorDelegate?

    private var state = State.initial

    private let sessionSetupQueue = DispatchQueue(label: "com.finess.CameraProcessor")

    deinit {
        let notificationObservations = notificationObservations

        switch state {
        case let .capturing(captureSession):
            captureSession.stopRunning()
        default:
            break
        }
        notificationObservations.forEach(NotificationCenter.default.removeObserver)
    }

    public init(
        cameraAuthorizationRequester: CameraAuthorizationRequester,
        cameraAuthorizationStatusChecker: CameraAuthorizationStatusChecker = DefaultCameraAuthorizationChecker(),
        cameraCaptureSessionProvider: CameraCaptureSessionProvider
    ) {
        self.cameraAuthorizationStatusChecker = cameraAuthorizationStatusChecker
        self.cameraAuthorizationRequester = cameraAuthorizationRequester
        self.cameraCaptureSessionProvider = cameraCaptureSessionProvider
    }

    public func startCapturing() {
        guard canStartCapturing() else { return }

        let authorizationStatus = cameraAuthorizationStatusChecker.check()
        handleAuthorizationStatus(authorizationStatus)
    }

    public func stopCapturing() {
        switch state {
        case let .capturing(captureSession):
            captureSession.stopRunning()
            state = .stopped
        default:
            break
        }
    }

    private func canStartCapturing() -> Bool {
        switch state {
        case .initial,
            .denied,
            .failed,
            .authorized,
            .stopped:
            return true
        case .authorizing,
            .capturing(_):
            return false
        }
    }

    private func handleAuthorizationStatus(_ status: CameraAuthorizationStatus) {
        switch status {
        case .authorized:
            sessionSetupQueue.async {
                do {
                    let captureSession = try self.cameraCaptureSessionProvider
                        .preparedCaptureSession()

                    DispatchQueue.main.async {
                        self.state = .capturing(captureSession)

                        captureSession.startRunning()
                        self.delegate?.cameraProcessor(self, didObtain: captureSession)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.state = .failed
                        self.delegate?.cameraProcessorCapturingWasFailed(self)
                    }
                }
            }
        case .notDetermined:
            state = .authorizing
            cameraAuthorizationRequester.requestCameraAuthorization { [weak self] status in
                self?.handleAuthorizationStatus(status)
            }

        case .denied:
            DispatchQueue.main.async {
                self.state = .denied
                self.delegate?.cameraProcessorCapturingWasDenied(self)
            }
        }
    }
}

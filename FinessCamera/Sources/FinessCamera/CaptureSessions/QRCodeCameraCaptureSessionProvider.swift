//
//  QRCodeCameraCaptureSessionProvider.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import AVFoundation
import Foundation

public final class QRCodeCameraCaptureSessionProvider {
    nonisolated(unsafe) public weak var delegate: CaptureSessionQRCodesDelegate?

    public init() {}
}

extension QRCodeCameraCaptureSessionProvider: CameraCaptureSessionProvider {
    public func preparedCaptureSession() throws -> CaptureSession {

        let avCaptureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            throw CameraFailure.captureSessionPreparationFailure
        }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            throw CameraFailure.captureSessionPreparationFailure
        }

        if avCaptureSession.canAddInput(videoInput) {
            avCaptureSession.addInput(videoInput)
        } else {
            throw CameraFailure.captureSessionPreparationFailure
        }

        let captureSession = QRCodeCaptureSession(captureSession: avCaptureSession)
        captureSession.delegate = self.delegate

        let metadataOutput = AVCaptureMetadataOutput()
        if avCaptureSession.canAddOutput(metadataOutput) {
            avCaptureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(
                captureSession,
                queue: captureSession.metadataQueue
            )
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            throw CameraFailure.captureSessionPreparationFailure
        }

        return captureSession
    }
}

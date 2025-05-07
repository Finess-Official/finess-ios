//
//  CaptureSessionQRCodesDelegate.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import AVFoundation
import UIKit

public protocol CaptureSessionQRCodesDelegate: AnyObject, Sendable {
    @MainActor
    func captureSession(
        _: CaptureSession,
        didObtainQRCodes qrCodes: [QRCodeCaptureSession.QRCode]
    )
}

@MainActor
public final class QRCodeCaptureSession: NSObject {
    nonisolated private let captureSession: AVCaptureSession

    nonisolated(unsafe) weak var delegate: CaptureSessionQRCodesDelegate?

    public struct QRCode: Sendable {
        public let value: String
        public let previewFrame: CGRect
    }

    var photoOutput: AVCapturePhotoOutput?
    let previewVideoLayer: AVCaptureVideoPreviewLayer

    let metadataQueue =
        DispatchQueue(label: "com.finess.QRCodeCaptureSession")

    public lazy var previewView: UIView =
        ResizableVideoView(previewVideoLayer: previewVideoLayer)

    nonisolated init(
        captureSession: AVCaptureSession
    ) {
        self.captureSession = captureSession
        self.previewVideoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    }
}

extension QRCodeCaptureSession: CaptureSession {
    public var isRunning: Bool {
        return captureSession.isRunning
    }

    public func startRunning() {
        captureSession.startRunning()
    }

    public func stopRunning() {
        captureSession.stopRunning()
    }
}

extension QRCodeCaptureSession: AVCaptureMetadataOutputObjectsDelegate {
    nonisolated public func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let delegate = delegate else { return }

        let codes = metadataObjects.compactMap { metadataObject -> QRCode? in
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                let stringValue = readableObject.stringValue
            else {
                return nil
            }
            let frame = previewVideoLayer.layerRectConverted(
                fromMetadataOutputRect: readableObject.bounds
            )
            return QRCode(value: stringValue, previewFrame: frame)
        }

        DispatchQueue.main.async {
            guard self.isRunning else {
                return
            }
            delegate.captureSession(
                self,
                didObtainQRCodes: codes
            )
        }
    }
}

extension AVCaptureSession: @retroactive @unchecked Sendable {}
extension AVCaptureVideoPreviewLayer: @retroactive @unchecked Sendable {}

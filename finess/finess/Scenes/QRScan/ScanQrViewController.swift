//
//  ScanQrViewControllerDelegate.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import Combine
import UIKit
import FinessCamera

public protocol ScanQrViewControllerDelegate: AnyObject {
    func scanQrViewController(
        didRecognizeQRCodeId: String
    )
}

public final class ScanQrViewController: UIViewController {
    public weak var delegate: ScanQrViewControllerDelegate?

    private let scanInputView: ScanQrInputView
    private let cameraProcessor: CameraProcessor

    private var captureSession: QRCodeCaptureSession?
    private var focusResetTimer: Timer?
    private let codeConverter = QRCodeConverter()

    public init(
    ) {
        self.scanInputView = ScanQrInputView()

        let cameraSessionProvider = QRCodeCameraCaptureSessionProvider()
        let requester = DefaultCameraAuthorizationRequester()

        cameraProcessor = CameraProcessor(
            cameraAuthorizationRequester: requester,
            cameraCaptureSessionProvider: cameraSessionProvider
        )

        super.init(nibName: nil, bundle: nil)

        cameraProcessor.delegate = self
        cameraSessionProvider.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .black
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scanInputView.changeMode(to: .none)
        cameraProcessor.startCapturing()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraProcessor.stopCapturing()
    }

    private func setupUI() {
        view.backgroundColor = .clear

        view.addSubview(scanInputView)

        scanInputView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scanInputView.topAnchor.constraint(equalTo: view.topAnchor),
            scanInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scanInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scanInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        scanInputView.viewportView.didTapOpenSettingsButton = { [weak self] in
            guard self != nil else { return }
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }

    private func setupFocusResetTimer() {
        guard
            focusResetTimer == nil
        else { return }

        focusResetTimer = Timer.scheduledTimer(
            withTimeInterval: 0.5,
            repeats: false
        ) { [weak self] _ in
            self?.resetFocus()
        }
    }

    private func invalidateFocusResetTimer() {
        focusResetTimer?.invalidate()
        focusResetTimer = nil
    }

    private func resetFocus() {
        scanInputView.updateQRObjectFocusFrame(nil)
    }
}

// MARK: - CameraProcessorDelegate

extension ScanQrViewController: CameraProcessorDelegate {
    public func cameraProcessor(_: CameraProcessor, didObtain captureSession: CaptureSession) {
        self.captureSession = captureSession as? QRCodeCaptureSession
        scanInputView.viewportView.previewView = captureSession.previewView
        scanInputView.changeMode(to: .scanQR(isCameraAccessed: true))
    }

    public func cameraProcessorCapturingWasFailed(_: CameraProcessor) {
        scanInputView.changeMode(to: .scanQR(isCameraAccessed: false))
    }

    public func cameraProcessorCapturingWasDenied(_: CameraProcessor) {
        scanInputView.changeMode(to: .scanQR(isCameraAccessed: false))
    }
}

// MARK: - CaptureSessionQRCodesDelegate

extension ScanQrViewController: CaptureSessionQRCodesDelegate {
    public func captureSession(_: CaptureSession, didObtainQRCodes qrCodes: [QRCodeCaptureSession.QRCode]) {
        if let code = qrCodes.first {
            invalidateFocusResetTimer()
            scanInputView.updateQRObjectFocusFrame(code.previewFrame)

            guard let qrCodeId = codeConverter.convert(code: code) else {
                return
            }

            delegate?.scanQrViewController(
                didRecognizeQRCodeId: qrCodeId
            )
        } else {
            setupFocusResetTimer()
        }
    }
}

//
//  ScanQrInputView.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import UIKit

final class ScanQrInputView: UIView {
    let viewportView = CameraViewportView()
    let scannerView: QRScannerControlsView

    private let qrInputText: NSAttributedString?

    enum Mode {
        case scanQR(isCameraAccessed: Bool)
        case none
    }

    private(set) var mode: Mode = .none

    init() {
        scannerView = QRScannerControlsView()

        self.qrInputText = NSAttributedString(string: NSLocalizedString("scanQR", comment: ""))

        super.init(frame: .zero)

        addSubview(viewportView)
        addSubview(scannerView)

        scannerView.isHidden = true

        viewportView.translatesAutoresizingMaskIntoConstraints = false
        scannerView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            viewportView.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewportView.topAnchor.constraint(equalTo: topAnchor),
            viewportView.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewportView.bottomAnchor.constraint(equalTo: bottomAnchor),

            scannerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scannerView.topAnchor.constraint(equalTo: topAnchor),
            scannerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scannerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)

        updateUI()
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateQRObjectFocusFrame(_ focusFrame: CGRect?) {
        scannerView.focusView.objectFrame = focusFrame
    }

    func changeMode(to mode: Mode) {
        let oldView = activeView(for: self.mode)
        let newView = activeView(for: mode)

        self.mode = mode
        updateUI()

        newView?.alpha = 0
        newView?.isHidden = false

        UIView.animate(withDuration: 0.3) {
            newView?.alpha = 1
            oldView?.alpha = 0
        } completion: { isSuccess in
            oldView?.isHidden = isSuccess
        }
    }

    private func updateUI() {
        switch mode {
        case let .scanQR(isCameraAccessed):
            scannerView.title = qrInputText
            viewportView.isNoCameraAccessViewHidden = isCameraAccessed
        case .none:
            break
        }
    }

    private func activeView(for mode: Mode) -> UIView? {
        switch mode {
        case let .scanQR(isCameraAccessed):
            return isCameraAccessed ? scannerView : nil
        case .none:
            return nil
        }
    }
}

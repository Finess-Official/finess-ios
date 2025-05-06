//
//  ResizableVideoView.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import AVFoundation
import UIKit

final class ResizableVideoView: UIView {
    let previewVideoLayer: AVCaptureVideoPreviewLayer

    convenience init(
        captureSession: AVCaptureSession
    ) {
        let previewVideoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.init(previewVideoLayer: previewVideoLayer)
    }

    init(
        previewVideoLayer: AVCaptureVideoPreviewLayer
    ) {
        self.previewVideoLayer = previewVideoLayer
        previewVideoLayer.videoGravity = .resizeAspectFill

        super.init(frame: .zero)
        layer.addSublayer(previewVideoLayer)
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewVideoLayer.frame = frame
    }
}

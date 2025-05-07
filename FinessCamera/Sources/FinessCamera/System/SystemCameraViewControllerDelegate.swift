//
//  SystemCameraViewControllerDelegate.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import Foundation
import UIKit

public protocol SystemCameraViewControllerDelegate: AnyObject {
    func systemCameraViewController(_ viewController: SystemCameraViewController, didFinishWith photo: UIImage)
    func systemCameraViewControllerDidFinishWithEmptyResult(_ viewController: SystemCameraViewController)
    func systemCameraViewControllerDidCancel(_ viewController: SystemCameraViewController)
}

public extension SystemCameraViewControllerDelegate {
    func systemCameraViewController(_ viewController: SystemCameraViewController, didFinishWith photo: UIImage) {}
    func systemCameraViewControllerDidFinishWithEmptyResult(_ viewController: SystemCameraViewController) {}
    func systemCameraViewControllerDidCancel(_ viewController: SystemCameraViewController) {}
}

public final class SystemCameraViewController: UIImagePickerController {
    public weak var cameraDelegate: SystemCameraViewControllerDelegate?
}

extension SystemCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[.originalImage] as? UIImage {
            cameraDelegate?.systemCameraViewController(self, didFinishWith: image)
        } else {
            cameraDelegate?.systemCameraViewControllerDidFinishWithEmptyResult(self)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        cameraDelegate?.systemCameraViewControllerDidCancel(self)
    }
}

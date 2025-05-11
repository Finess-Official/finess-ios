//
//  MainCoordinator.swift
//  finess
//
//  Created by Elina Karapetyan on 27.04.2025.
//

import UIKit

class MainCoordinator {
    private let mainViewController = MainViewController()
    private let qrProvider = QRProvider()
    private let addAccountViewController: AddAccountViewController
    private let createQRViewController: CreateQRViewController
    private let scanQrViewController = ScanQrViewController()
    private var mainNavigationController: UINavigationController

    init() {
        self.addAccountViewController = AddAccountViewController(provider: qrProvider)
        self.createQRViewController = CreateQRViewController(provider: qrProvider)
        self.mainNavigationController = UINavigationController(rootViewController: mainViewController)
        mainViewController.delegate = self
        addAccountViewController.delegate = self
        createQRViewController.delegate = self
        scanQrViewController.delegate = self
    }

    func start() -> UINavigationController {
        mainNavigationController.navigationBar.tintColor = .black
        return mainNavigationController
    }
}

extension MainCoordinator: MainViewControllerDelegate {
    func didTapScanQRCodeButton() {
        mainNavigationController.modalPresentationStyle = .fullScreen
        mainNavigationController.present(scanQrViewController, animated: true)
    }

    func didTapCreateQRCodeButton() {
        mainNavigationController.pushViewController(addAccountViewController, animated: true)
    }
}

extension MainCoordinator: AddAccountViewControllerDelegate {
    func accountDidCreated() {
        mainNavigationController.pushViewController(createQRViewController, animated: true)
    }
}

extension MainCoordinator: CreateQRViewControllerDelegate {
    func didTapCreateButton(with qrCodeId: String) {
        let qrViewController = QRViewController(qrCodeId: qrCodeId)
        mainNavigationController.pushViewController(qrViewController, animated: true)
    }
}

extension MainCoordinator: ScanQrViewControllerDelegate {
    func scanQrViewController(didRecognizeQRCodeId: String) {
        
    }
}

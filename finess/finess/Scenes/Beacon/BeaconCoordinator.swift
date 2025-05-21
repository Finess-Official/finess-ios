//
//  MainCoordinator.swift
//  finess
//
//  Created by Elina Karapetyan on 21.05.2025.
//

import UIKit
import CoreLocation

class BeaconCoordinator {
    private let beaconViewController: BeaconViewController
    private let qrProvider = QRProvider()
    private let beaconProvider = BeaconProvider()
    private let beaconManager = BeaconManager()
    private let addAccountViewController: AddAccountViewController
    private let enterSummViewController: EnterSummViewController
    private var mainNavigationController: UINavigationController

    init() {
        self.addAccountViewController = AddAccountViewController(provider: qrProvider)
        self.beaconViewController = BeaconViewController(beaconManager: beaconManager)
        self.mainNavigationController = UINavigationController(rootViewController: beaconViewController)
        self.enterSummViewController = EnterSummViewController(provider: BeaconProvider())
        enterSummViewController.delegate = self
        beaconViewController.delegate = self
        addAccountViewController.delegate = self
    }

    func start() -> UINavigationController {
        mainNavigationController.navigationBar.tintColor = .black
        beaconManager.locationManager.requestAlwaysAuthorization()
        return mainNavigationController
    }
}

extension BeaconCoordinator: BeaconViewControllerDelegate {
    func didTapStopBroadcasting() {
        beaconManager.stopBroadcasting()
    }
    
    func didTapBroadcastButton() {
        let accountData = Auth.shared.getAccountData()
        if accountData.name == nil || accountData.cardNumber == nil || accountData.inn == nil || accountData.bik == nil {
            mainNavigationController.present(addAccountViewController, animated: true)
        } else {
            mainNavigationController.present(enterSummViewController, animated: true)
        }
    }

    func didTapScanButton() {
        if beaconManager.uuid == nil {
            beaconProvider.getBeaconConfig { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(config):
                    print("success: \(config)")
                    beaconManager.monitorBeacons(uuid: UUID(uuidString: config.bluetoothId)!)
                case let .failure(error):
                    print("error \(error)")
                }
            }
        } else {
            beaconManager.monitorBeacons(uuid: beaconManager.uuid!)
        }
        beaconViewController.setScanningMode(true)
    }
}

extension BeaconCoordinator: AddAccountViewControllerDelegate {
    func accountDidCreated() {
        addAccountViewController.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            mainNavigationController.present(enterSummViewController, animated: true)
        }
    }
}

extension BeaconCoordinator: EnterSummViewControllerDelegate {
    func didTapCreateButton(uuid: String, major: UInt16, minor: UInt16) {
        DispatchQueue.main.async { [weak self] in
            self?.enterSummViewController.dismiss(animated: true) { [weak self] in
                guard let self else { return }
                beaconManager.startBroadcasting(uuid: UUID(uuidString: uuid)!, major: major, minor: minor)
                beaconViewController.setBroadcastingMode(true)
            }
        }
    }
}

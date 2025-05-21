//
//  BeaconManager.swift
//  finess
//
//  Created by Elina Karapetyan on 21.05.2025.
//

import Foundation
import CoreLocation
import CoreBluetooth

final class BeaconManager: NSObject, CLLocationManagerDelegate {
    private var peripheralManager: CBPeripheralManager?
    private var major: CLBeaconMajorValue = 0
    private var minor: CLBeaconMinorValue = 0

    var uuid: UUID? = nil

    var onBeaconFound: ((UUID, Int, Int, Int) -> Void)?

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()

    // Функция для начала вещания как маяк
    func startBroadcasting(uuid: UUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue) {
        self.uuid = uuid
        self.major = major
        self.minor = minor

        guard let peripheralManager = peripheralManager,
              peripheralManager.state == .poweredOn else {
            print("Bluetooth не включен")
            return
        }

        let region = CLBeaconRegion(
            uuid: uuid,
            major: major,
            minor: minor,
            identifier: "com.example.myBeaconRegion"
        )

        guard let beaconPeripheralData = region.peripheralData(withMeasuredPower: nil) as? [String: Any] else {
            print("Не удалось создать данные для вещания")
            return
        }

        peripheralManager.startAdvertising(beaconPeripheralData)
        print("Начало вещания как маяк")
    }

    // Функция для остановки вещания
    func stopBroadcasting() {
        peripheralManager?.stopAdvertising()
        print("Вещание остановлено")
    }

    // Существующий метод для мониторинга маяков
    func monitorBeacons(uuid: UUID) {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            let constraint = CLBeaconIdentityConstraint(uuid: uuid)
            let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "com.example.myBeaconRegion")
            locationManager.startRangingBeacons(satisfying: constraint)
        }
    }

    func locationManager(_ manager: CLLocationManager,
                didEnterRegion region: CLRegion) {
        print("TEST: didEnterRegion \(region.identifier)")
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: any Error) {
        print("TEST: error")
    }

    func locationManager(_ manager: CLLocationManager,
                didRangeBeacons beacons: [CLBeacon],
                         in region: CLBeaconRegion) {
        print("TEST: didRange \(beacons.count)")

        // Обработка найденных маяков
        for beacon in beacons {
            onBeaconFound?(beacon.uuid,
                          beacon.major.intValue,
                          beacon.minor.intValue,
                          beacon.rssi)
        }
    }
}

// Расширение для обработки состояния Bluetooth
extension BeaconManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("Bluetooth включен и готов к работе")
        case .poweredOff:
            print("Bluetooth выключен")
        case .resetting:
            print("Состояние Bluetooth сбрасывается")
        case .unauthorized:
            print("Нет разрешения на использование Bluetooth")
        case .unknown:
            print("Неизвестное состояние Bluetooth")
        case .unsupported:
            print("Bluetooth не поддерживается на этом устройстве")
        @unknown default:
            print("Неизвестное состояние Bluetooth")
        }
    }
}

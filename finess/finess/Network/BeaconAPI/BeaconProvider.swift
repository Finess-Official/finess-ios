//
//  BeaconProvider.swift
//  finess
//
//  Created by Elina Karapetyan on 21.05.2025.
//

import Foundation
import Logging

class BeaconProvider {
    private let client: BeaconClient
    private let logger = Logger(label: "com.finess.beaconProviderError")

    init(client: BeaconClient = BeaconClientImpl()) {
        self.client = client
    }

    func createBeacon(amount: Float, completion: @escaping (Result<BeaconInfoResponse, APIErrorHandler>) -> Void) {
        let account = Auth.shared.getAccountData()
        guard let ownerName = account.name,
              let inn = account.inn,
              let bik = account.bik,
              let accountNumber = account.cardNumber
        else {
            logger.error("Can not create beacon")
            return
        }

        let params = BeaconCreationParams(
            amount: amount,
            account: CreateAccountParams(
                ownerName: ownerName,
                inn: inn,
                bik: bik,
                accountNumber: accountNumber
            )
        )

        client.request(
            with: BeaconAPI.createBeacon(params: params),
            map: BeaconCreationDTOToDomainConverter.convert(from:),
            completion: completion
        )
    }

    func getBeaconConfig(completion: @escaping (Result<BeaconConfigResponse, APIErrorHandler>) -> Void) {
        client.request(
            with: BeaconAPI.getConfig(),
            map: BeaconConfigDTOToDomainConverter.convert(_:),
            completion: completion
        )
    }

    func getPaymentInfo(major: UInt16, minor: UInt16, completion: @escaping (Result<BeaconInfoResponse, APIErrorHandler>) -> Void) {
        client.request(
            with: BeaconAPI.getBeacon(major: major, minor: minor),
            map: BeaconCreationDTOToDomainConverter.convert(from:),
            completion: completion
        )
    }
}

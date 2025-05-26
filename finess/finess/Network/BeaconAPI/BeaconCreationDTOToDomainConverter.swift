//
//  BeaconCreationDTOToDomainConverter.swift
//  finess
//
//  Created by Elina Karapetyan on 21.05.2025.
//

import Foundation

struct BeaconCreationDTOToDomainConverter {
    static func convert(from dto: BeaconInfoResult) -> BeaconInfoResponse {
        return BeaconInfoResponse(
            id: dto.id,
            major: dto.major,
            minor: dto.minor,
            bluetoothId: dto.bluetoothId,
            account: AccountDTOToDomainConverter.convert(from: dto.account)
        )
    }
}

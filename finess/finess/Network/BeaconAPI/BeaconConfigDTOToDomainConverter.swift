//
//  BeaconConfigDTOToDomainConverter.swift
//  finess
//
//  Created by Elina Karapetyan on 21.05.2025.
//

import Foundation

struct BeaconConfigDTOToDomainConverter {
    static func convert(_ dto: BeaconConfigResult) -> BeaconConfigResponse {
        BeaconConfigResponse(bluetoothId: dto.bluetoothId)
    }
}

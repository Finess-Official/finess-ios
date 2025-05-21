//
//  BeaconInfoResponse.swift
//  finess
//
//  Created by Elina Karapetyan on 21.05.2025.
//

import Foundation

struct BeaconInfoResponse {
    let major: UInt16
    let minor: UInt16
    let bluetoothId: String
    let account: CreateAccountResponse
}

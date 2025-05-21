//
//  BeaconCreationParams.swift
//  finess
//
//  Created by Elina Karapetyan on 21.05.2025.
//

import Foundation

struct BeaconCreationParams: Codable {
    let amount: Float
    let account: CreateAccountParams
}

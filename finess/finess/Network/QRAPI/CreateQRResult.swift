//
//  CreateQRResult.swift
//  finess
//
//  Created by Elina Karapetyan on 03.05.2025.
//

import Foundation

struct CreateQRResult: Decodable {
    let id: String
    let accountId: String
    let amount: Float
}

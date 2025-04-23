//
//  CreateAccountResult.swift
//  finess
//
//  Created by Elina Karapetyan on 23.04.2025.
//

import Foundation

struct CreateAccountResult: Decodable {
    let id: String
    let ownerName: String
    let inn: String
    let bik: String
    let accountNumber: String
}

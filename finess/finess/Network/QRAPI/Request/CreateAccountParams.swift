//
//  CreateAccount.swift
//  finess
//
//  Created by Elina Karapetyan on 23.04.2025.
//

import Foundation

struct CreateAccountParams: Codable {
    let ownerName: String
    let inn: String
    let bik: String
    let accountNumber: String
}

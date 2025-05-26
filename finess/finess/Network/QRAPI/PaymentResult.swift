//
//  PaymentResult.swift
//  finess
//
//  Created by Elina Karapetyan on 26.05.2025.
//

import Foundation

struct PaymentResult: Decodable {
    enum Status: String, Decodable {
        case failed = "FAILED"
        case completed = "COMPLETED"
    }

    struct User: Decodable {
        let id: String
        let firstName: String
        let lastName: String
        let middleName: String
    }

    struct Recipient: Decodable {
        let account: CreateAccountResult
        let profile: User
    }

    enum PaymentMethod: String, Decodable {
        case beacon = "BEACON"
        case qrCode = "QRCODE"
    }

    let id: String
    let status: Status
    let amount: Float
    let createdAt: Date
    let sender: User
    let recipient: Recipient
    let paymentMethod: PaymentMethod
}

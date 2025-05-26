//
//  PaymentResultDomain.swift
//  finess
//
//  Created by Elina Karapetyan on 26.05.2025.
//

import Foundation

struct PaymentResponse {
    enum Status {
        case failed
        case completed
    }

    struct User {
        let id: String
        let firstName: String
        let lastName: String
        let middleName: String
    }

    struct Recipient {
        let account: CreateAccountResponse
        let profile: User
    }

    enum PaymentMethod {
        case beacon
        case qrCode
    }

    let id: String
    let status: Status
    let amount: Float
    let createdAt: Date
    let sender: User
    let recipient: Recipient
    let paymentMethod: PaymentMethod
}

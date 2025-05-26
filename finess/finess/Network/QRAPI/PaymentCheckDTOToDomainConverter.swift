//
//  PaymentDTOToDomainConverter.swift
//  finess
//
//  Created by Elina Karapetyan on 26.05.2025.
//

import Foundation

struct PaymentCheckDTOToDomainConverter {
    static func convert(_ dto: [PaymentResult]) -> [PaymentResponse] {
        return dto.map { check in
            return PaymentResponse(
                id: check.id,
                status: convert(check.status),
                amount: check.amount,
                createdAt: check.createdAt,
                sender: PaymentResponse.User(id: check.sender.id, firstName: check.sender.firstName, lastName: check.sender.lastName, middleName: check.sender.middleName),
                recipient: PaymentResponse.Recipient(account: AccountDTOToDomainConverter.convert(from: check.recipient.account), profile: PaymentResponse.User(id: check.recipient.profile.id, firstName: check.recipient.profile.firstName, lastName: check.recipient.profile.lastName, middleName: check.recipient.profile.middleName)),
                paymentMethod: convert(check.paymentMethod)
            )
        }
    }

    static func convert(_ dto: PaymentResult.Status) -> PaymentResponse.Status {
        switch dto {
        case .failed:
            return .failed
        case .completed:
            return .completed
        }
    }

    static func convert(_ dto: PaymentResult.PaymentMethod) -> PaymentResponse.PaymentMethod {
        switch dto {
        case .beacon:
            return .beacon
        case .qrCode:
            return .qrCode
        }
    }
}

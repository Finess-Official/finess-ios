//
//  QRDTOToDomainConverter.swift
//  finess
//
//  Created by Elina Karapetyan on 03.05.2025.
//

import Foundation

struct QRDTOToDomainConverter {
    static func convert(from dto: CreateQRResult) -> CreateQRResponse {
        return CreateQRResponse(
            id: dto.id,
            accountId: dto.accountId,
            amount: dto.amount
        )
    }
}

//
//  QRProvider.swift
//  finess
//
//  Created by Elina Karapetyan on 23.04.2025.
//

import Foundation
import Logging

enum QRProviderState {
    case idle
    case accountCreated(accountId: String)
}

final class QRProvider {
    private let client: QRClient
    private let logger = Logger(label: "com.finess.qrProviderError")

    private var state: QRProviderState = .idle

    init(client: QRClient = QRClientImpl()) {
        self.client = client
    }

    func createAccount(
        ownerName: String?,
        inn: String?,
        bik: String?,
        accountNumber: String?,
        completion: @escaping (Result<Void, APIErrorHandler>) -> Void
    ) {
        guard let ownerName, let inn, let bik, let accountNumber else {
            logger.error("Missing account creation input")
            return
        }

        let params = CreateAccountParams(ownerName: ownerName, inn: inn, bik: bik, accountNumber: accountNumber)

        state = .idle

        client.request(
            with: QRAPI.createAccount(params: params),
            map: AccountDTOToDomainConverter.convert(from:)
        ) { [weak self] result in
            switch result {
            case .success(let account):
                self?.state = .accountCreated(accountId: account.id)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createQR(
        amount: String?,
        completion: @escaping (Result<CreateQRResponse, APIErrorHandler>) -> Void
    ) {
        guard case let .accountCreated(accountId) = state else {
            logger.error("Attempt to create QR before account was created")
            return
        }

        guard let amount, let floatValue = Float(amount) else {
            logger.error("Invalid amount for QR")
            return
        }

        let params = CreateQRParams(accountId: accountId, amount: floatValue)

        client.request(
            with: QRAPI.createQR(params: params),
            map: QRDTOToDomainConverter.convert(from:),
            completion: completion
        )
    }

    func getQR(
        qrCodeId: String?,
        completion: @escaping (Result<CreateQRResponse, APIErrorHandler>) -> Void
    ) {
        guard let qrCodeId else { return }
        
        client.request(
            with: QRAPI.getQR(qrCodeId: qrCodeId),
            map: QRDTOToDomainConverter.convert(from:),
            completion: completion
        )
    }
}


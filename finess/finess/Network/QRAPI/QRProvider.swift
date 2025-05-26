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

enum PaymentType: String {
    case qr = "QRCODE"
    case beacon = "BEACON"
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

    func getAccounts(completion: @escaping (Result<AccountsInfoResponse, APIErrorHandler>) -> Void) {
        client.request(
            with: QRAPI.getAccounts(),
            map: AccountsInfoDTOToDomainConverter.convert(_:),
            completion: completion)
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
        qrCodeId: String,
        qrCompletion: @escaping (Result<Float, APIErrorHandler>) -> Void,
        accountCompletion: @escaping (Result<TransferDetailsResponse, APIErrorHandler>) -> Void
    ) {
        client.request(
            with: QRAPI.getQR(qrCodeId: qrCodeId),
            map: QRDTOToDomainConverter.convert(from:),
            completion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    qrCompletion(.success(success.amount))
                    self.client.request(with: QRAPI.getAccount(accountId: success.accountId), map: AccountDTOToDomainConverter.convert(from:)) { result in
                        switch result {
                        case .success(let success):
                            accountCompletion(.success(TransferDetailsResponse(name: success.ownerName, cardNumber: success.accountNumber)))
                        case .failure(let failure):
                            qrCompletion(.failure(failure))
                            accountCompletion(.failure(failure))
                        }
                    }
                case .failure(let failure):
                    qrCompletion(.failure(failure))
                    accountCompletion(.failure(failure))
                }
            }
        )
    }

    func initializePaymentQR(
        qrCodeId: String,
        type: PaymentType,
        completion: @escaping (Result<PaymentInitializationTask, APIErrorHandler>) -> Void
    ) {
        let params = PaymentCreationParamsQR(
            associationId: .init(type: type.rawValue, qrCodeId: qrCodeId)
        )

        client.request(
            with: QRAPI.initPaymentQR(params: params),
            map: PaymentDTOToDomainConverter.convert(from:),
            completion: completion
        )
    }

    func initializePaymentBeacon(
        qrCodeId: String,
        type: PaymentType,
        completion: @escaping (Result<PaymentInitializationTask, APIErrorHandler>) -> Void
    ) {
        let params = PaymentCreationParamsBeacon(
            associationId: .init(type: type.rawValue, beaconId: qrCodeId)
        )

        client.request(
            with: QRAPI.initPaymentBeacon(params: params),
            map: PaymentDTOToDomainConverter.convert(from:),
            completion: completion
        )
    }

    func getPaymentInitStatus(
        paymentTaskId: String,
        completion: @escaping (Result<String?, APIErrorHandler>) -> Void) {
            client.request(
                with: QRAPI.getInitStatus(paymentId: paymentTaskId),
                map: PaymentDTOToDomainConverter.convert(from:)) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let success):
                        switch success.status {
                        case .initialized:
                            completion(.success(success.acquiringPaymentUrl))
                        case .inProgress:
                            self.getPaymentInitStatus(paymentTaskId: success.id, completion: completion)
                        case .failed:
                            completion(.failure(.badRequest))
                        }
                    case .failure(let failure):
                        completion(.failure(failure))
                    }
                }
    }
}


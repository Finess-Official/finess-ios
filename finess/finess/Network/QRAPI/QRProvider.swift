//
//  QRProvider.swift
//  finess
//
//  Created by Elina Karapetyan on 23.04.2025.
//

import Foundation

class QRProvider {
    let client: QRClient

    init(client: QRClient = QRClientImpl()) {
        self.client = client
    }
    
    func createAccount(ownerName: String?,
                       inn: String?,
                       bik: String?,
                       accountNumber: String?,
                       completion: @escaping (Result<CreateAccountResponse, APIErrorHandler>) -> Void
    ) {
        guard let ownerName = ownerName,
              let inn = inn,
              let bik = bik,
              let accountNumber = accountNumber else {
            return
        }

        let params = CreateAccountParams(ownerName: ownerName, inn: inn, bik: bik, accountNumber: accountNumber)
        client.request(client: URLSession.shared, with: QRAPI.createAccount(params: params)) { result in
            completion(result)
        }
    }
}

//
//  Result+Extensions.swift
//  finess
//
//  Created by Elina Karapetyan on 03.05.2025.
//

import Foundation

extension Result {
    func logFailure(using logger: APILoggingService) -> Self {
        if case let .failure(error as APIErrorHandler) = self {
            logger.log(error: error)
        }
        return self
    }
}

import Foundation

enum PaymentDTOToDomainConverter {
    static func convert(from dto: PaymentInitializationTaskDTO) -> PaymentInitializationTask {
        return PaymentInitializationTask(
            id: dto.id,
            status: convertStatus(status: dto.status),
            acquiringPaymentUrl: dto.acquiringPaymentUrl,
            createdAt: dto.createdAt
        )
    }

    static func convertStatus(status: PaymentInitializationTaskDTO.PaymentStatus) -> PaymentInitializationTask.PaymentStatus {
        switch status {
        case .initialized: .initialized
        case .inProgress: .inProgress
        case .failed: .failed
        }
    }
}

struct PaymentInitializationTaskDTO: Codable {
    let id: String
    let status: PaymentStatus
    let acquiringPaymentUrl: String?
    let createdAt: Date

    enum PaymentStatus: String, Codable {
        case initialized = "INITIALIZED"
        case inProgress = "IN_PROGRESS"
        case failed = "FAILED"
    }
}

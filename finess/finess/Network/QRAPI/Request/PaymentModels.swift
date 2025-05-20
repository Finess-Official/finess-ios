import Foundation

struct PaymentCreationParams: Codable {
    let type: String
    let qrCodeId: String
}

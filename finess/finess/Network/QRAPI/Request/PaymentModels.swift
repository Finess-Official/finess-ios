import Foundation

struct PaymentCreationParams: Codable {

    let associationId: AssociationId

    struct AssociationId: Codable {
        let type: String
        let qrCodeId: String
    }
}

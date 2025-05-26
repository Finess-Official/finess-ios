import Foundation

struct PaymentCreationParamsQR: Codable {

    let associationId: AssociationId

    struct AssociationId: Codable {
        let type: String
        let qrCodeId: String
    }
}

struct PaymentCreationParamsBeacon: Codable {

    let associationId: AssociationId

    struct AssociationId: Codable {
        let type: String
        let beaconId: String
    }
}

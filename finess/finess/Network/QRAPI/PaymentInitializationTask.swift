//
//  PaymentInitializationTask.swift
//  finess
//
//  Created by Elina Karapetyan on 20.05.2025.
//

import Foundation

struct PaymentInitializationTask: Codable {
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

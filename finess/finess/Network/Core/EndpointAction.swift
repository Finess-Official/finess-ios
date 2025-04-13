//
//  EndpointAction.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import Foundation

enum EndpointAction {
    case request
    case requestWithJSONBody(Encodable & Sendable)
}

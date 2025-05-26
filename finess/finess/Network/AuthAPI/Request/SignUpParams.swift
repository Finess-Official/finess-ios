//
//  AuthSignUpParams.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import Foundation

struct SignUpParams: Encodable {
    let password: String
    let firstName: String
    let lastName: String
    let middleName: String
}

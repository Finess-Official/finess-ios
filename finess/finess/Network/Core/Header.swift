//
//  Header.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import Foundation

struct Header: Sendable {
    var name: String
    var value: String

    init(
        name: String,
        value: String
    ) {
        self.name = name
        self.value = value
    }
}

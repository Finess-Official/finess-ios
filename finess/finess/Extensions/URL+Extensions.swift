//
//  URL+Extensions.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import Foundation

extension URL {
    
    public var params: [String: String] {
        guard let components = URLComponents(string: absoluteString) else {
            return [:]
        }
        return (components.queryItems ?? [])
            .reduce(into: [String: String]()) { params, item in
                params[item.name] = item.value
            }
    }
}

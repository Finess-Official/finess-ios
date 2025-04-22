//
//  APIProvider.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import Foundation

typealias URLEncodable = [String: Any]

protocol APIProvider {
    var path: String { get }
    var queryParameters: URLEncodable { get }
    var headers: [Header] { get }
    var method: EndpointMethod { get }
    var action: EndpointAction { get }
}


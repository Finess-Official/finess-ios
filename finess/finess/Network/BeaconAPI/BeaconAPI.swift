//
//  BeaconAPI.swift
//  finess
//
//  Created by Elina Karapetyan on 21.05.2025.
//

import Foundation

struct BeaconAPI: APIProvider {
    var path: String
    var queryParameters: URLEncodable
    var headers: [Header]
    var method: EndpointMethod
    var action: EndpointAction

    private init(
        method: EndpointMethod,
        path: String,
        queryParameters: URLEncodable = [:],
        action: EndpointAction,
        headers: [Header] = []
    ) {
        self.method = method
        self.path = path
        self.queryParameters = queryParameters
        self.action = action
        self.headers = headers
    }
}

extension BeaconAPI {
    static func createBeacon(params: BeaconCreationParams) -> BeaconAPI {
        BeaconAPI(
            method: .post,
            path: "/beacons",
            action: .requestWithJSONBody(params)
        )
    }

    static func getBeacon(major: UInt16, minor: UInt16) -> BeaconAPI {
        BeaconAPI(
            method: .get,
            path: "/beacons?major=\(major)&minor=\(minor)",
            action: .request
        )
    }

    static func getConfig() -> BeaconAPI {
        BeaconAPI(
            method: .get,
            path: "/beacons/configuration",
            action: .request
        )
    }
}

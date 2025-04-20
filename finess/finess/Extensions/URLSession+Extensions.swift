//
//  URLSession+Extensions.swift
//  finess
//
//  Created by Elina Karapetyan on 20.04.2025.
//

import Foundation

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func createDataTask(with request: URLRequest, completionHandler: @escaping @Sendable DataTaskResult) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    func createDataTask(with request: URLRequest, completionHandler: @escaping @Sendable DataTaskResult) -> URLSessionDataTask {
        dataTask(with: request, completionHandler: completionHandler)
    }
}

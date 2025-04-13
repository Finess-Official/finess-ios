//
//  ToDoApp.swift
//  finess
//
//  Created by Elina Karapetyan on 13.04.2025.
//

import Foundation

enum FinessApp {
    static let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as! String
    
    enum Path {
        static let identity = "/api/identity/v1"
    }
}

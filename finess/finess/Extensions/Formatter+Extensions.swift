//
//  Formatter+Extensions.swift
//  finess
//
//  Created by Elina Karapetyan on 10.04.2025.
//

import Foundation

extension Formatter {
   static var customISO8601DateFormatter: ISO8601DateFormatter = {
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      return formatter
   }()
}

//
//  String+Extensions.swift
//  finess
//
//  Created by Elina Karapetyan on 27.04.2025.
//

import Foundation

extension String{

    private static let decimalFormatter:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()

    private var decimalSeparator:String{
        return String.decimalFormatter.decimalSeparator ?? "."
    }

    func isValidDecimal(maximumFractionDigits:Int)->Bool{
        guard self.isEmpty == false else {
            return true
        }

        if let _ = String.decimalFormatter.number(from: self){
            let numberComponents = self.components(separatedBy: decimalSeparator)
            let fractionDigits = numberComponents.count == 2 ? numberComponents.last ?? "" : ""
            return fractionDigits.count <= maximumFractionDigits
        }

        return false
    }

}

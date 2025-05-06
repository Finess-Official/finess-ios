//
//  UIColor+Extensions.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import UIKit

extension UIColor {

    convenience init(
        rgbHex: Int,
        alpha: CGFloat = 1
    ) {
        let red: CGFloat = CGFloat((rgbHex >> 16) & 0xFF) / CGFloat(0xFF)
        let green: CGFloat = CGFloat((rgbHex >> 8) & 0xFF) / CGFloat(0xFF)
        let blue: CGFloat = CGFloat((rgbHex >> 0) & 0xFF) / CGFloat(0xFF)

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

}

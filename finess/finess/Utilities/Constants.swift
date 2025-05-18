//
//  Constants.swift
//  finess
//
//  Created by Elina Karapetyan on 13.04.2025.
//

import UIKit

enum Constants {
    // UIFont
    static let errorFont: UIFont = .systemFont(ofSize: Constants.errorLableFontSize, weight: .regular)
    static let titleFont: UIFont = .systemFont(ofSize: Constants.titleFontSize, weight: .bold)
    static let subtitleFont: UIFont = .systemFont(ofSize: Constants.subtitleFontSize, weight: .regular)
    static let largeButtonFont: UIFont = .systemFont(ofSize: Constants.largeButtonFontSize, weight: .medium)
    static let middleButtonFont: UIFont = .systemFont(ofSize: Constants.middleButtonFontSize, weight: .medium)
    static let smallButtonFont: UIFont = .systemFont(ofSize: Constants.smallButtonFontSize, weight: .regular)

    // FontSize
    static let errorLableFontSize: CGFloat = 13
    static let titleFontSize: CGFloat = 32
    static let subtitleFontSize: CGFloat = 16
    static let largeButtonFontSize: CGFloat = 17
    static let middleButtonFontSize: CGFloat = 12
    static let smallButtonFontSize: CGFloat = 16

    // TextAlignment
    static let textAlignment: NSTextAlignment = .left

    // UIColor
    static let disabledButtonColor = UIColor.disabledButton
    static let activeButtonColor = UIColor.activeButton
    static let errorColor: UIColor = .red
    static let textColor: UIColor = .black
    static let transparentTextColor: UIColor = .black.withAlphaComponent(0.5)
    static let normalButtonColor: UIColor = .black
    static let buttonTitleColor: UIColor = .white
    static let authBackgroundColor: UIColor = .white
    static let mainViewButtonBackgroundColor: UIColor = .white
    static let tabBarActive = UIColor.tabBarActive
    static let tabBarInactive = UIColor.tabBarInactive
    static let backgroundColor = UIColor.white
    static let tabBarBorderColor = UIColor.gray.cgColor

    // Numeric
    static let buttonHeight: CGFloat = 48
    static let buttonCornerRadius: CGFloat = buttonHeight / 2
    static let textFieldHeight: CGFloat = 56
    static let largeSpacing: CGFloat = 48
    static let mediumSpacing: CGFloat = 32
    static let smallSpacing: CGFloat = 16
    static let minSymbolCount: Int = 6
    static let maxSymbolCount: Int = 72
    static let textFieldCornerRadius: CGFloat = 16
    static let mainViewButtonCornerRadius: CGFloat = 24
    static let mainViewButtonInnerViewSize: CGFloat = 50
    static let mainViewButtonInnerViewCornerRadius: CGFloat = mainViewButtonInnerViewSize / 2
    static let mainViewButtonHeight: CGFloat = 105
    static let tabBarBorderWidth = 0.5
    static let maximumFractionDigits = 2

    // Padding
    static let textFieldPadding = UIEdgeInsets(top: .zero, left: Constants.textFieldLeftPadding, bottom: .zero, right: Constants.textFieldRightPadding)
    static let textFieldLeftPadding: CGFloat = 20
    static let textFieldRightPadding: CGFloat = 40
    static let horizontalPadding: CGFloat = 16
    static let errorLabelLeadingPadding: CGFloat = Constants.textFieldLeftPadding + Constants.horizontalPadding
    static let errorLabelTopPadding: CGFloat = 4
    static let titleTopPadding: CGFloat = 32

    // Image
    static let qrIcon = UIImage.QR
    static let addIcon = UIImage.addQR
}

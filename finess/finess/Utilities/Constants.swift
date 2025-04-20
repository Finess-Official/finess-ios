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
    static let largeButtonFont: UIFont = .systemFont(ofSize: Constants.largeButtonFontSize, weight: .medium)
    static let middleButtonFont: UIFont = .systemFont(ofSize: Constants.middleButtonFontSize, weight: .medium)
    static let smallButtonFont: UIFont = .systemFont(ofSize: Constants.smallButtonFontSize, weight: .regular)

    // FontSize
    static let errorLableFontSize: CGFloat = 13
    static let titleFontSize: CGFloat = 32
    static let largeButtonFontSize: CGFloat = 17
    static let middleButtonFontSize: CGFloat = 12
    static let smallButtonFontSize: CGFloat = 16

    // TextAlignment
    static let textAlignment: NSTextAlignment = .left

    // UIColor
    static let disabledButtonColor = UIColor(named: "DisabledButton")
    static let activeButtonColor = UIColor(named: "ActiveButton")
    static let errorColor: UIColor = .red
    static let textColor: UIColor = .black
    static let normalButtonColor: UIColor = .black
    static let buttonTitleColor: UIColor = .white
    static let authBackgroundColor: UIColor = .white
    static let tabBarActive = UIColor(named: "TabBarActive")
    static let tabBarInactive = UIColor(named: "TabBarInactive")
    static let backgroundColor = UIColor(named: "BackgroundColor")

    // Numeric
    static let buttonHeight: CGFloat = 48
    static let buttonCornerRadius: CGFloat = buttonHeight / 2
    static let textFieldHeight: CGFloat = 56
    static let spacing: CGFloat = 36
    static let minSymbolCount: Int = 6
    static let maxSymbolCount: Int = 72
    static let textFieldCornerRadius: CGFloat = 16

    // Padding
    static let textFieldPadding = UIEdgeInsets(top: .zero, left: Constants.textFieldLeftPadding, bottom: .zero, right: Constants.textFieldRightPadding)
    static let textFieldLeftPadding: CGFloat = 20
    static let textFieldRightPadding: CGFloat = 40
    static let horizontalPadding: CGFloat = 16
    static let errorLabelLeadingPadding: CGFloat = Constants.textFieldLeftPadding + Constants.horizontalPadding
    static let errorLabelTopPadding: CGFloat = 4
    static let titleTopPadding: CGFloat = 32

    // Text
    static let lessThanSixSymbols = "В пароле меньше 6 символов"
    static let password = "Пароль"
    static let signIn = "Вход"
    static let signinButton = "Войти"
    static let createAccount = "Нет аккаунта? Создайте его"
    static let passwordsDontMatch = "Пароли не совпадают"
    static let signUp = "Регистрация"
    static let signupButton = "Зарегистрироваться"
    static let haveAccountSignIn = "Уже есть аккаунт? Войти"
    static let repeatPassword = "Повторите пароль"
    static let qrIconTitle = "QR"

    // Image
    static let qrIcon = UIImage(named: qrIconTitle)
    static let addIcon = UIImage(named: "AddQR")
}

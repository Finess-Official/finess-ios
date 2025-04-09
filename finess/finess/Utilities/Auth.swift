//
//  Auth.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import SwiftUI
import SwiftKeychainWrapper
import Combine

class Auth: ObservableObject {

    struct Credentials {
        var accessToken: String?
        var refreshToken: String?
    }

    enum KeychainKey: String {
        case accessToken
        case refreshToken
    }

    static let shared: Auth = Auth()
    private let keychain: KeychainWrapper = KeychainWrapper.standard

    let loggedIn = CurrentValueSubject<Bool, Never>(false)

    private init() {
        withAnimation {
            loggedIn.send(hasAccessToken())
        }
    }

    func getCredentials() -> Credentials {
        return Credentials(
            accessToken: keychain.string(forKey: KeychainKey.accessToken.rawValue),
            refreshToken: keychain.string(forKey: KeychainKey.refreshToken.rawValue)
        )
    }

    func setCredentials(accessToken: String, refreshToken: String) {
        keychain.set(accessToken, forKey: KeychainKey.accessToken.rawValue)
        keychain.set(refreshToken, forKey: KeychainKey.refreshToken.rawValue)

        withAnimation {
            loggedIn.send(true)
        }
    }

    func hasAccessToken() -> Bool {
        return getCredentials().accessToken != nil
    }

    func getAccessToken() -> String? {
        return getCredentials().accessToken
    }

    func getRefreshToken() -> String? {
        return getCredentials().refreshToken
    }

    func logout() {
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.accessToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.refreshToken.rawValue)

        withAnimation {
            loggedIn.send(false)
        }
    }

}

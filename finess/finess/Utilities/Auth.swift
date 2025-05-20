//
//  Auth.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import SwiftUI
import SwiftKeychainWrapper
import Combine

protocol AuthProtocol: ObservableObject {
    var loggedIn: CurrentValueSubject<Bool, Never> { get }
    func signIn(password: String, completion: @escaping (APIErrorHandler?) -> Void)
    func signUp(password: String, completion: @escaping (APIErrorHandler?) -> Void)
    func getCredentials() -> Auth.Credentials
    func logout()
}

class Auth: AuthProtocol {
    struct Credentials {
        var accessToken: String?
        var refreshToken: String?
    }

    enum KeychainKey: String {
        case accessToken
        case refreshToken
        case userId
        case accessTokenExpirationDate
        case refreshTokenExpirationDate
    }

    static let shared: Auth = Auth()

    private let keychain: KeychainWrapper = KeychainWrapper.standard
    private let authClient: AuthClient

    enum AuthResult {
        case success
        case error(localizedText: String?)
    }

    var isSignedUp: Bool { getUserId() != nil }
    let loggedIn = CurrentValueSubject<Bool, Never>(false)

    private init() {
        authClient = AuthClientImpl()
        withAnimation {
            loggedIn.send(hasAccessToken())
        }
    }

    func signIn(password: String, completion: @escaping (APIErrorHandler?) -> Void) {
        guard let userId = getUserId() else { completion(.unauthorized); return }
        authClient.request(with: AuthAPI.signIn(params: SignInParams(userId: userId, password: password))) { result in
            switch result {
            case let .success(success):
                Auth.shared.setCredentials(authData: success)
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }

    func signUp(password: String, completion: @escaping (APIErrorHandler?) -> Void) {
        authClient.request(with: AuthAPI.signUp(params: SignUpParams(password: password))) { result in
            switch result {
            case let .success(success):
                Auth.shared.setCredentials(authData: success)
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }

    func logout() {
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.accessToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.refreshToken.rawValue)

        withAnimation {
            loggedIn.send(false)
        }
    }

    func getCredentials() -> Credentials {
        return Credentials(
            accessToken: keychain.string(forKey: KeychainKey.accessToken.rawValue),
            refreshToken: keychain.string(forKey: KeychainKey.refreshToken.rawValue)
        )
    }

    private func setCredentials(authData: AuthResponse) {
        keychain.set(authData.accessToken, forKey: KeychainKey.accessToken.rawValue)
        keychain.set(authData.sessionExpiresAt.timeIntervalSince1970, forKey: KeychainKey.accessTokenExpirationDate.rawValue)
        keychain.set(authData.refreshToken, forKey: KeychainKey.refreshToken.rawValue)
        keychain.set(authData.refreshTokenExpiresAt.timeIntervalSince1970, forKey: KeychainKey.refreshTokenExpirationDate.rawValue)
        keychain.set(authData.userId, forKey: KeychainKey.userId.rawValue)

        withAnimation {
            loggedIn.send(true)
        }
    }

    private func getUserId() -> String? {
        return keychain.string(forKey: KeychainKey.userId.rawValue)
    }

    private func hasAccessToken() -> Bool {
        guard getCredentials().accessToken != nil,
              let refreshTokenExpirationDate = keychain.double(forKey: KeychainKey.refreshTokenExpirationDate.rawValue) else {
            return false
        }

        let currentDate = Date().timeIntervalSince1970
        if currentDate < refreshTokenExpirationDate {
            return true
        } else {
            return false
        }
    }
}

//
//  BZKManager.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// The entry point for talking to the ListenBrainz API.
///
/// Create one manager for your app and keep it for its lifetime.
///
/// ```swift
/// let manager = BZKManager(
///     clientInfo: BZKClientInfo(name: "MyPlayer", version: "1.0", contact: "https://example.com")
/// )
/// try await manager.signIn(token: userToken)
/// ```
public actor BZKManager {
    /// Identifies your app to ListenBrainz.
    public let clientInfo: BZKClientInfo
    /// The signed-in user's token, or `nil` when signed out.
    public private(set) var token: String?
    /// The signed-in user's name, or `nil` when signed out.
    public private(set) var userName: String?
    let httpClient: any BZKHTTPClient

    /// Creates a manager.
    ///
    /// - Parameters:
    ///   - clientInfo: Identifies your app to ListenBrainz.
    ///   - token: A previously saved user token.
    ///   - userName: The user name that belongs to `token`.
    ///   - httpClient: The transport used for requests. Defaults to `URLSession.shared`.
    public init(
        clientInfo: BZKClientInfo,
        token: String? = nil,
        userName: String? = nil,
        httpClient: any BZKHTTPClient = URLSession.shared
    ) {
        self.clientInfo = clientInfo
        self.token = token
        self.userName = userName
        self.httpClient = httpClient
    }

    /// Restores a previously validated user without contacting ListenBrainz.
    ///
    /// - Parameters:
    ///   - token: The user token.
    ///   - userName: The user name that belongs to `token`.
    public func setToken(_ token: String, userName: String) {
        self.token = token
        self.userName = userName
    }

    /// Validates a user token and signs the user in.
    ///
    /// Users find their token on their ListenBrainz settings page.
    ///
    /// - Parameter token: The user token.
    /// - Returns: The user name that belongs to the token.
    /// - Throws: ``BZKClientError/invalidToken`` if ListenBrainz does not accept the token.
    @discardableResult
    public func signIn(token: String) async throws -> String {
        guard let userName = try await validateToken(token) else {
            throw BZKClientError.invalidToken
        }
        setToken(token, userName: userName)
        return userName
    }

    /// Checks a user token without signing in.
    ///
    /// - Parameter token: The user token.
    /// - Returns: The user name that belongs to the token, or `nil` if the token is invalid.
    public func validateToken(_ token: String) async throws -> String? {
        let request = BZKRequest(path: "validate-token", token: token)
        let validation: BZKTokenValidation = try await perform(request)
        return validation.valid ? validation.userName : nil
    }

    /// Forgets the signed-in user.
    public func signOut() {
        token = nil
        userName = nil
    }
}

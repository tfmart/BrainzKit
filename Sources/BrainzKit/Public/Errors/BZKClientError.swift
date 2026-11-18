//
//  BZKClientError.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// Errors BrainzKit detects without ListenBrainz rejecting a request.
public enum BZKClientError: Error, LocalizedError, Sendable, Equatable {
    /// The action requires a signed-in user.
    case missingToken
    /// ListenBrainz did not accept the user token.
    case invalidToken
    /// A request URL could not be built.
    case badURL
    /// ListenBrainz returned a response that was not HTTP.
    case invalidResponse
    /// ListenBrainz has no data for the request yet, for example statistics that have not been calculated.
    case noContent
    /// No listens were provided.
    case noListens
    /// More than 1000 listens were provided in one request.
    case tooManyListens

    /// A localized description of the error.
    public var errorDescription: String? {
        switch self {
        case .missingToken:
            return NSLocalizedString("A ListenBrainz user token is required. Sign in before performing this action.", comment: "")
        case .invalidToken:
            return NSLocalizedString("The ListenBrainz user token is not valid.", comment: "")
        case .badURL:
            return NSLocalizedString("The request URL could not be built.", comment: "")
        case .invalidResponse:
            return NSLocalizedString("ListenBrainz returned an unexpected response.", comment: "")
        case .noContent:
            return NSLocalizedString("ListenBrainz has no data for this request yet.", comment: "")
        case .noListens:
            return NSLocalizedString("No listens were provided.", comment: "")
        case .tooManyListens:
            return NSLocalizedString("ListenBrainz accepts at most 1000 listens per request.", comment: "")
        }
    }
}

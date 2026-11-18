//
//  BZKError.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// An error returned by ListenBrainz.
public struct BZKError: Error, LocalizedError, Sendable, Equatable {
    /// The HTTP status code.
    public let statusCode: Int
    /// The error message from ListenBrainz, if it sent one.
    public let message: String?
    /// The number of seconds until the rate limit resets, if ListenBrainz reported it.
    public let rateLimitResetIn: TimeInterval?

    /// Whether the request was rejected for exceeding the rate limit.
    public var isRateLimited: Bool {
        statusCode == 429
    }

    /// A localized description of the error.
    public var errorDescription: String? {
        message ?? HTTPURLResponse.localizedString(forStatusCode: statusCode)
    }

    init(response: HTTPURLResponse, data: Data) {
        statusCode = response.statusCode
        message = (try? JSONDecoder().decode(BZKErrorMessage.self, from: data))?.error
        rateLimitResetIn = response.value(forHTTPHeaderField: "X-RateLimit-Reset-In").flatMap(TimeInterval.init)
    }
}

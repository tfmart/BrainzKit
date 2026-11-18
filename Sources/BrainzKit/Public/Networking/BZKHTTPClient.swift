//
//  BZKHTTPClient.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A transport that performs HTTP requests for ``BZKManager``.
///
/// `URLSession` conforms out of the box. Provide your own conformance to route requests through custom networking, logging, or a configured session.
public protocol BZKHTTPClient: Sendable {
    /// Performs a request and returns the response body and metadata.
    ///
    /// - Parameter request: The request to perform.
    func response(for request: URLRequest) async throws -> (Data, URLResponse)
}

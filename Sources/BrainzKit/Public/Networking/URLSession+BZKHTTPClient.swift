//
//  URLSession+BZKHTTPClient.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession: BZKHTTPClient {
    /// Performs a request using this session.
    ///
    /// - Parameter request: The request to perform.
    public func response(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}

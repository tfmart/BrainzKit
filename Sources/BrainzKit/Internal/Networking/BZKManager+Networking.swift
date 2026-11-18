//
//  BZKManager+Networking.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension BZKManager {
    static let baseURL = "https://api.listenbrainz.org/1/"

    func requiredToken() throws -> String {
        guard let token else { throw BZKClientError.missingToken }
        return token
    }

    func makeURLRequest(for request: BZKRequest) throws -> URLRequest {
        guard var components = URLComponents(string: Self.baseURL + request.path) else {
            throw BZKClientError.badURL
        }
        if !request.queryItems.isEmpty {
            components.queryItems = request.queryItems
            components.percentEncodedQuery = components.percentEncodedQuery?
                .replacingOccurrences(of: "+", with: "%2B")
        }
        guard let url = components.url else { throw BZKClientError.badURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue(clientInfo.userAgent, forHTTPHeaderField: "User-Agent")
        if let token = request.token ?? token {
            urlRequest.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = request.body {
            urlRequest.httpBody = body
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }

    @discardableResult
    func send(_ request: BZKRequest) async throws -> Data {
        let (data, response) = try await httpClient.response(for: makeURLRequest(for: request))
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BZKClientError.invalidResponse
        }
        switch httpResponse.statusCode {
        case 204:
            throw BZKClientError.noContent
        case 200..<300:
            return data
        default:
            throw BZKError(response: httpResponse, data: data)
        }
    }

    func perform<Response: Decodable>(_ request: BZKRequest) async throws -> Response {
        let data = try await send(request)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(Response.self, from: data)
    }

    func encode<Body: Encodable>(_ body: Body) throws -> Data {
        try JSONEncoder().encode(body)
    }
}

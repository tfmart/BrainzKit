//
//  FakeListenBrainz.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

struct FakeListenBrainz: BZKHTTPClient {
    let status: Int
    let body: String
    let headers: [String: String]
    let log = RequestLog()

    init(status: Int = 200, body: String = #"{"status": "ok"}"#, headers: [String: String] = [:]) {
        self.status = status
        self.body = body
        self.headers = headers
    }

    func response(for request: URLRequest) async throws -> (Data, URLResponse) {
        await log.append(request)
        let url = try #require(request.url)
        let response = try #require(HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: headers))
        return (Data(body.utf8), response)
    }

    func manager(signedIn: Bool = true) -> BZKManager {
        BZKManager(
            clientInfo: BZKClientInfo(name: "TestPlayer", version: "2.1", contact: "https://example.com"),
            token: signedIn ? "user-token" : nil,
            userName: signedIn ? "listener" : nil,
            httpClient: self
        )
    }

    func lastRequest() async throws -> URLRequest {
        try #require(await log.requests.last)
    }

    func lastJSONBody() async throws -> [String: Any] {
        let body = try #require(try await lastRequest().httpBody)
        return try #require(try JSONSerialization.jsonObject(with: body) as? [String: Any])
    }
}

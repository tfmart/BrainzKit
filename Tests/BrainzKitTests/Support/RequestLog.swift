//
//  RequestLog.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

actor RequestLog {
    private(set) var requests: [URLRequest] = []

    func append(_ request: URLRequest) {
        requests.append(request)
    }
}

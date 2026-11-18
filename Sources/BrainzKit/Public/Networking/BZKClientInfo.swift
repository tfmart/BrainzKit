//
//  BZKClientInfo.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// Identifies your app to ListenBrainz.
///
/// ListenBrainz requires every request to carry a user agent with your app's name, version, and a way to contact you, and may block requests without one. BrainzKit also records the name and version as the submission client of every listen you submit.
public struct BZKClientInfo: Sendable, Hashable {
    /// Your app's name, without a version.
    public let name: String
    /// Your app's version.
    public let version: String
    /// A URL or email address ListenBrainz can use to reach you.
    public let contact: String

    /// Creates client information.
    ///
    /// - Parameters:
    ///   - name: Your app's name, without a version.
    ///   - version: Your app's version.
    ///   - contact: A URL or email address ListenBrainz can use to reach you.
    public init(name: String, version: String, contact: String) {
        self.name = name
        self.version = version
        self.contact = contact
    }

    var userAgent: String {
        "\(name)/\(version) ( \(contact) )"
    }
}

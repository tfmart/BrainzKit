//
//  BZKManager+Account.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Starts preparing an archive of the signed-in user's listens, feedback, and other data.
    ///
    /// Check its progress with ``dataExport(id:)`` and download it with ``downloadDataExport(id:)`` once it's ``BZKDataExportStatus/completed``.
    ///
    /// - Parameters:
    ///   - start: Only include data from this date onward.
    ///   - end: Only include data up to this date.
    /// - Returns: The queued export. If one is already in progress, that export is returned.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    @discardableResult
    func startDataExport(from start: Date? = nil, to end: Date? = nil) async throws -> BZKDataExport {
        let body = BZKDataExportBody(
            startTime: start.map { Int($0.timeIntervalSince1970) },
            endTime: end.map { Int($0.timeIntervalSince1970) }
        )
        let request = try BZKRequest(method: .post, path: "export/", body: encode(body), token: requiredToken())
        return try await perform(request)
    }

    /// Fetches the signed-in user's data exports.
    ///
    /// - Returns: The exports, newest first.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func dataExports() async throws -> [BZKDataExport] {
        try await perform(BZKRequest(path: "export/list", token: requiredToken()))
    }

    /// Fetches one of the signed-in user's data exports.
    ///
    /// - Parameter id: The export's ID.
    /// - Returns: The export.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` with status 404 if the user has no export with that ID.
    func dataExport(id: Int) async throws -> BZKDataExport {
        try await perform(BZKRequest(path: "export/\(id)", token: requiredToken()))
    }

    /// Downloads a completed data export.
    ///
    /// - Parameter id: The export's ID.
    /// - Returns: The archive's contents as ZIP data.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` with status 404 if the export isn't ready or doesn't exist.
    func downloadDataExport(id: Int) async throws -> Data {
        try await send(BZKRequest(path: "export/\(id)/download", token: requiredToken()))
    }

    /// Deletes one of the signed-in user's data exports.
    ///
    /// - Parameter id: The export's ID.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` with status 404 if the user has no export with that ID.
    func deleteDataExport(id: Int) async throws {
        try await send(BZKRequest(method: .post, path: "export/\(id)/delete", token: requiredToken()))
    }

    /// Fetches the services the signed-in user has connected on listenbrainz.org, such as "spotify".
    ///
    /// - Returns: The connected services' names.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func connectedServices() async throws -> [String] {
        let response: BZKServicesResponse = try await perform(BZKRequest(path: "\(signedInUserPath())/services"))
        return response.services
    }

    /// Fetches the date of the newest listen a user imported from a service, so an importer can resume from there.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - service: The service's name, such as "lastfm" or "librefm".
    /// - Returns: The date, or `nil` if the user hasn't imported from the service.
    /// - Throws: ``BZKError`` with status 404 if the user or service doesn't exist.
    func latestImport(forUser userName: String, service: String = "lastfm") async throws -> Date? {
        let request = BZKRequest(path: "latest-import", queryItems: BZKRequest.query(["user_name": userName, "service": service]))
        let response: BZKLatestImportResponse = try await perform(request)
        return response.latestImport > 0 ? Date(timeIntervalSince1970: TimeInterval(response.latestImport)) : nil
    }

    /// Records the date of the newest listen the signed-in user imported from a service.
    ///
    /// The date can only move forward: ListenBrainz ignores dates earlier than the one already recorded, and there's no way to clear it.
    ///
    /// - Parameters:
    ///   - date: The newest imported listen's date.
    ///   - service: The service's name, such as "lastfm" or "librefm".
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the service doesn't exist.
    func setLatestImport(_ date: Date, service: String = "lastfm") async throws {
        let body = BZKLatestImportBody(ts: Int(date.timeIntervalSince1970), service: service)
        try await send(BZKRequest(method: .post, path: "latest-import", body: encode(body), token: requiredToken()))
    }
}

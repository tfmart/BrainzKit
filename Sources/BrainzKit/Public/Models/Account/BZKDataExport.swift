//
//  BZKDataExport.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// An archive of a user's ListenBrainz data, prepared in the background.
public struct BZKDataExport: Sendable, Hashable, Decodable, Identifiable {
    /// The export's ID.
    public let id: Int
    /// The export's progress, or `nil` if this version of BrainzKit doesn't recognize it.
    public let status: BZKDataExportStatus?
    /// A human-readable description of the progress.
    public let progress: String?
    /// When the export was requested.
    public let createdAt: Date?
    /// When the archive will be deleted, once it's ready.
    public let availableUntil: Date?
    /// The archive's file name, once it's ready.
    public let filename: String?

    enum CodingKeys: String, CodingKey {
        case id = "export_id"
        case status
        case progress
        case createdAt = "created"
        case availableUntil = "available_until"
        case filename
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        status = (try? container.decodeIfPresent(String.self, forKey: .status)).flatMap { $0.flatMap(BZKDataExportStatus.init(rawValue:)) }
        progress = try container.decodeIfPresent(String.self, forKey: .progress)
        createdAt = BZKISODate.parse(try container.decodeIfPresent(String.self, forKey: .createdAt))
        availableUntil = BZKISODate.parse(try container.decodeIfPresent(String.self, forKey: .availableUntil))
        filename = try container.decodeIfPresent(String.self, forKey: .filename)
    }
}

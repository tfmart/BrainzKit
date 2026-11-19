//
//  BZKDataExportStatus.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The progress of a data export.
public enum BZKDataExportStatus: String, Sendable, Hashable, CaseIterable, Decodable {
    /// The export is queued.
    case waiting
    /// The export is being prepared.
    case inProgress = "in_progress"
    /// The export is ready to download.
    case completed
    /// The export failed.
    case failed
}

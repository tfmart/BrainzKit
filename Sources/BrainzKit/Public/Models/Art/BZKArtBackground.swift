//
//  BZKArtBackground.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The background behind a cover art grid.
public enum BZKArtBackground: String, Sendable, Hashable, CaseIterable {
    /// A transparent background.
    case transparent
    /// A white background.
    case white
    /// A black background.
    case black
}

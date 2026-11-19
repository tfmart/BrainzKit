//
//  BZKFlair.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// An animated effect on a donor's user name across listenbrainz.org.
public enum BZKFlair: String, Sendable, Hashable, CaseIterable, Codable {
    /// Shake.
    case shake
    /// A sweep in ListenBrainz colors.
    case colorSweep = "lb-colors-sweep"
    /// A light sweep.
    case lightSweep = "light-sweep"
    /// A wave.
    case wave
    /// A horizontal flip.
    case flipHorizontal = "flip-horizontal"
    /// A vertical flip.
    case flipVertical = "flip-vertical"
    /// A 3D flip.
    case flip3D = "flip-3d"
    /// Extruded text.
    case extruded
    /// An underline.
    case underline
    /// A tornado.
    case tornado
    /// A highlighter.
    case highlighter
    /// An anaglyph 3D effect.
    case anaglyph
    /// Sliced text.
    case sliced
}

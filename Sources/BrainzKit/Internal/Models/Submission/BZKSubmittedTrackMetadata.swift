//
//  BZKSubmittedTrackMetadata.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKSubmittedTrackMetadata: Encodable {
    let artistName: String
    let trackName: String
    let releaseName: String?
    let additionalInfo: BZKSubmittedAdditionalInfo

    enum CodingKeys: String, CodingKey {
        case artistName = "artist_name"
        case trackName = "track_name"
        case releaseName = "release_name"
        case additionalInfo = "additional_info"
    }

    init(listen: BZKListenSubmission, clientInfo: BZKClientInfo) {
        artistName = listen.artist
        trackName = listen.track
        releaseName = listen.release
        additionalInfo = BZKSubmittedAdditionalInfo(listen: listen, clientInfo: clientInfo)
    }
}

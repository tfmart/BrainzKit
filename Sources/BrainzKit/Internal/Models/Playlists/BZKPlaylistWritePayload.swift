//
//  BZKPlaylistWritePayload.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPlaylistWritePayload: Encodable {
    var title: String?
    var annotation: String?
    var extensions: [String: BZKPlaylistWriteExtension]?
    var track: [BZKPlaylistWriteTrack]?

    enum CodingKeys: String, CodingKey {
        case title
        case annotation
        case extensions = "extension"
        case track
    }

    init(title: String?, annotation: String?, isPublic: Bool?, collaborators: [String]?, recordingMBIDs: [String]?) {
        self.title = title
        self.annotation = annotation
        if isPublic != nil || collaborators != nil {
            extensions = ["https://musicbrainz.org/doc/jspf#playlist": BZKPlaylistWriteExtension(isPublic: isPublic, collaborators: collaborators)]
        }
        track = recordingMBIDs?.map(BZKPlaylistWriteTrack.init(recordingMBID:))
    }
}

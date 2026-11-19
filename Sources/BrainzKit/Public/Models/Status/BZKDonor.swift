//
//  BZKDonor.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// Someone who donated to the MetaBrainz Foundation, which runs ListenBrainz.
public struct BZKDonor: Sendable, Hashable, Decodable {
    /// The donor's MusicBrainz user name.
    public let userName: String
    /// The donated amount.
    public let amount: Double
    /// The donation's currency code, such as "usd".
    public let currency: String
    /// When the donation was made.
    public let donatedAt: Date?
    /// Whether the donor has a ListenBrainz account.
    public let isListenBrainzUser: Bool
    /// The donor's flair, if they chose one and show it.
    public let flair: BZKFlair?

    enum CodingKeys: String, CodingKey {
        case userName = "musicbrainz_id"
        case amount = "donation"
        case currency
        case donatedAt = "donated_at"
        case isListenBrainzUser = "is_listenbrainz_user"
        case flair
        case showFlair = "show_flair"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userName = try container.decode(String.self, forKey: .userName)
        amount = try container.decode(Double.self, forKey: .amount)
        currency = try container.decode(String.self, forKey: .currency)
        donatedAt = BZKISODate.parse(try container.decodeIfPresent(String.self, forKey: .donatedAt))
        isListenBrainzUser = try container.decodeIfPresent(Bool.self, forKey: .isListenBrainzUser) ?? false
        let showsFlair = try container.decodeIfPresent(Bool.self, forKey: .showFlair) ?? true
        let flairName = try container.decodeIfPresent(String.self, forKey: .flair)
        flair = showsFlair ? flairName.flatMap(BZKFlair.init(rawValue:)) : nil
    }
}

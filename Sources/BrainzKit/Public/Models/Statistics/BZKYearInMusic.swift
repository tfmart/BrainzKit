//
//  BZKYearInMusic.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A user's Year in Music: a summary of everything they listened to in one year.
public struct BZKYearInMusic: Sendable, Hashable, Decodable {
    /// The year summarized.
    public let year: Int
    /// The number of listens.
    public let totalListenCount: Int?
    /// The total listening time in seconds.
    public let totalListeningTime: TimeInterval?
    /// The number of different artists listened to.
    public let totalArtistCount: Int?
    /// The number of artists listened to for the first time.
    public let newArtistCount: Int?
    /// The number of different recordings listened to.
    public let totalRecordingCount: Int?
    /// The number of different release groups listened to.
    public let totalReleaseGroupCount: Int?
    /// The weekday with the most listens.
    public let mostActiveWeekday: BZKWeekday?
    /// The most listened artists.
    public let topArtists: [BZKArtistStatistic]
    /// The most listened recordings.
    public let topRecordings: [BZKRecordingStatistic]
    /// The most listened release groups.
    public let topReleaseGroups: [BZKReleaseGroupStatistic]
    /// The most listened genres.
    public let topGenres: [BZKGenreShare]
    /// The number of listens on each day of the year, in chronological order.
    public let listensPerDay: [BZKListeningActivity]
    /// The number of listens to music released in each year, keyed by release year.
    public let listensByReleaseYear: [Int: Int]
    /// The users with the most similar taste that year, most similar first.
    public let similarUsers: [BZKSimilarUser]
    /// Listens grouped by artist country.
    public let artistCountries: [BZKCountryStatistic]
    /// A playlist of the year's top tracks the user listened to for the first time.
    public let topDiscoveriesPlaylist: BZKPlaylist?
    /// A playlist of tracks similar users loved that year and the user missed.
    public let missedRecordingsPlaylist: BZKPlaylist?

    enum CodingKeys: String, CodingKey {
        case year
        case data
    }

    enum DataKeys: String, CodingKey {
        case totalListenCount = "total_listen_count"
        case totalListeningTime = "total_listening_time"
        case totalArtistCount = "total_artists_count"
        case newArtistCount = "total_new_artists_discovered"
        case totalRecordingCount = "total_recordings_count"
        case totalReleaseGroupCount = "total_release_groups_count"
        case dayOfWeek = "day_of_week"
        case topArtists = "top_artists"
        case topRecordings = "top_recordings"
        case topReleaseGroups = "top_release_groups"
        case topGenres = "top_genres"
        case listensPerDay = "listens_per_day"
        case mostListenedYear = "most_listened_year"
        case similarUsers = "similar_users"
        case artistMap = "artist_map"
        case topDiscoveries = "playlist-top-discoveries-for-year"
        case missedRecordings = "playlist-top-missed-recordings-for-year"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        year = try container.decode(Int.self, forKey: .year)
        let data = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        totalListenCount = try? data.decodeIfPresent(Int.self, forKey: .totalListenCount)
        totalListeningTime = try? data.decodeIfPresent(Double.self, forKey: .totalListeningTime)
        totalArtistCount = try? data.decodeIfPresent(Int.self, forKey: .totalArtistCount)
        newArtistCount = try? data.decodeIfPresent(Int.self, forKey: .newArtistCount)
        totalRecordingCount = try? data.decodeIfPresent(Int.self, forKey: .totalRecordingCount)
        totalReleaseGroupCount = try? data.decodeIfPresent(Int.self, forKey: .totalReleaseGroupCount)
        mostActiveWeekday = (try? data.decodeIfPresent(String.self, forKey: .dayOfWeek)).flatMap { $0.flatMap(BZKWeekday.init(rawValue:)) }
        topArtists = ((try? data.decodeIfPresent([BZKArtistStatistic].self, forKey: .topArtists)) ?? nil) ?? []
        topRecordings = ((try? data.decodeIfPresent([BZKRecordingStatistic].self, forKey: .topRecordings)) ?? nil) ?? []
        topReleaseGroups = ((try? data.decodeIfPresent([BZKReleaseGroupStatistic].self, forKey: .topReleaseGroups)) ?? nil) ?? []
        topGenres = ((try? data.decodeIfPresent([BZKGenreShare].self, forKey: .topGenres)) ?? nil) ?? []
        listensPerDay = ((try? data.decodeIfPresent([BZKListeningActivity].self, forKey: .listensPerDay)) ?? nil) ?? []
        let byYear = ((try? data.decodeIfPresent([String: Int].self, forKey: .mostListenedYear)) ?? nil) ?? [:]
        listensByReleaseYear = Dictionary(uniqueKeysWithValues: byYear.compactMap { key, value in Int(key).map { ($0, value) } })
        let similar = ((try? data.decodeIfPresent([String: Double].self, forKey: .similarUsers)) ?? nil) ?? [:]
        similarUsers = similar.map { BZKSimilarUser(userName: $0.key, similarity: $0.value) }.sorted { $0.similarity > $1.similarity }
        artistCountries = ((try? data.decodeIfPresent([BZKCountryStatistic].self, forKey: .artistMap)) ?? nil) ?? []
        topDiscoveriesPlaylist = (try? data.decodeIfPresent(BZKPlaylist.self, forKey: .topDiscoveries)) ?? nil
        missedRecordingsPlaylist = (try? data.decodeIfPresent(BZKPlaylist.self, forKey: .missedRecordings)) ?? nil
    }
}

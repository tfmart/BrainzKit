# BrainzKit

A Swift package for the [ListenBrainz](https://listenbrainz.org) API. Submit listens, update now playing, love recordings, and read listening history and statistics.

## Features

- Submit listens, now playing updates, and offline imports
- Read a user's listens, listen count, and now playing track
- Love and hate recordings, read feedback, and import loved tracks from Last.fm, Libre.fm, or Navidrome
- Personalized track recommendations, and ratings that tune them
- Fresh releases (sitewide or from artists a user listens to), releases by cover art color, and LB Radio playlists from prompts like `artist:(Daft Punk)`
- Pin a recording to a profile, and read pins from a user or the people they follow
- Browse, search, create, and edit playlists, including the ones ListenBrainz generates for each user, and move them to and from Spotify, Apple Music, and SoundCloud
- Top artists, releases, albums, and recordings, listening activity, listening heatmaps, and artist countries, for a user or the whole site
- Year in Music summaries, listens by album, release era, genre and hour, artist trends over time, an artist's or album's top listeners, and how similar two users' tastes are
- Shareable SVG images: top artist and album designs, cover art grids, and Year in Music cards
- Listen and listener counts for any artist, recording, or album, and an artist's most played tracks and albums
- Search, follow, and find similar users
- Read a user's feed, recommend tracks to followers, and post CritiqueBrainz reviews
- Match artist and track names to MusicBrainz recordings, and fix wrong matches
- Export a user's data as a ZIP archive, and track import progress from other services
- Update account settings like time zone and flair, and check service status and donors
- Genres, tags, release details, and streaming links for recordings, artists, and albums

## Requirements

- iOS 15, macOS 12, Mac Catalyst 15, watchOS 8, tvOS 15, or visionOS 1
- Swift 6.0

## Installation

Add BrainzKit with Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/tfmart/BrainzKit.git", from: "1.0.0")
]
```

## Usage

```swift
import BrainzKit

let manager = BZKManager(
    clientInfo: BZKClientInfo(name: "MyPlayer", version: "1.0", contact: "https://example.com")
)

try await manager.signIn(token: userToken)

try await manager.updatePlayingNow(
    BZKListenSubmission(artist: "Daft Punk", track: "One More Time")
)

try await manager.submitListen(
    BZKListenSubmission(artist: "Daft Punk", track: "One More Time", listenedAt: playbackStart)
)

let topArtists = try await manager.topArtists(for: .user("rob"), range: .thisMonth)
```

Users find their token on their [ListenBrainz settings page](https://listenbrainz.org/settings/).

## Documentation

The [full documentation](https://tfmart.github.io/BrainzKit/documentation/brainzkit/) covers every API and includes guides for getting started and submitting listens. To build it locally, choose Product > Build Documentation in Xcode, or run:

```bash
swift package --disable-sandbox preview-documentation --target BrainzKit
```

## License

BrainzKit is available under the MIT license. See [LICENSE](LICENSE) for details.

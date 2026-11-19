# BrainzKit

A Swift package for the [ListenBrainz](https://listenbrainz.org) API. Submit listens, update now playing, love recordings, and read listening history and statistics.

## Features

- Submit listens, now playing updates, and offline imports
- Read a user's listens, listen count, and now playing track
- Love and hate recordings, and read feedback
- Pin a recording to a profile, and read pins from a user or the people they follow
- Browse and search playlists, including the ones ListenBrainz generates for each user
- Top artists, releases, albums, and recordings, plus listening activity, for a user or the whole site
- Search, follow, and find similar users
- Match artist and track names to MusicBrainz recordings

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

# Submitting Listens

Report what a user is playing and what they finished listening to.

## Update now playing

When a track starts, call ``BZKManager/updatePlayingNow(_:)``. ListenBrainz shows it on the user's profile until another track starts or you call ``BZKManager/clearPlayingNow(onlyIfSubmittedByThisClient:)``:

```swift
let msid = try await manager.updatePlayingNow(
    BZKListenSubmission(artist: "Air", track: "La Femme d'Argent", release: "Moon Safari")
)
```

The returned recording MSID lets the user love the track straight away with ``BZKManager/submitFeedback(_:for:)``.

## Submit a listen

Submit a listen once the user has played half the track or four minutes of it, whichever comes first. Set ``BZKListenSubmission/listenedAt`` to the time playback started:

```swift
try await manager.submitListen(
    BZKListenSubmission(
        artist: "Air",
        track: "La Femme d'Argent",
        release: "Moon Safari",
        listenedAt: playbackStart,
        duration: 427
    )
)
```

## Add identifiers

ListenBrainz links listens to MusicBrainz recordings. Providing identifiers you already have, such as an ISRC or MusicBrainz IDs, makes that link more accurate:

```swift
var listen = BZKListenSubmission(artist: "Air", track: "Sexy Boy", listenedAt: playbackStart)
listen.isrc = "FRZ109700340"
listen.musicService = "music.apple.com"
```

If you only have names, ``BZKManager/lookupRecording(artist:track:release:)`` finds the matching MusicBrainz recording:

```swift
if let match = try await manager.lookupRecording(artist: "Air", track: "Sexy Boy") {
    listen.recordingMBID = match.recordingMBID
}
```

BrainzKit adds your app's name and version from ``BZKClientInfo`` to every listen.

## Submit listens recorded offline

Queue listens while the device is offline and send them later with ``BZKManager/importListens(_:)``, up to 1000 per call:

```swift
for batch in stride(from: 0, to: queued.count, by: 1000).map({ Array(queued[$0..<min($0 + 1000, queued.count)]) }) {
    try await manager.importListens(batch)
}
```

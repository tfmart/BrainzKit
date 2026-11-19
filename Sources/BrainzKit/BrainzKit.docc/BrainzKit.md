# ``BrainzKit``

Submit listens to ListenBrainz and read listening history, feedback, and statistics with Swift concurrency.

## Overview

BrainzKit wraps the [ListenBrainz API](https://listenbrainz.readthedocs.io/en/latest/users/api/index.html). Everything goes through ``BZKManager``: create one with your app's details, sign the user in with their ListenBrainz token, and call its methods.

```swift
import BrainzKit

let manager = BZKManager(
    clientInfo: BZKClientInfo(name: "MyPlayer", version: "1.0", contact: "https://example.com")
)

try await manager.signIn(token: userToken)
try await manager.submitListen(
    BZKListenSubmission(artist: "Daft Punk", track: "One More Time", listenedAt: startDate)
)
```

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:SubmittingListens>
- ``BZKManager``
- ``BZKClientInfo``

### Submitting Listens

- ``BZKManager/submitListen(_:)``
- ``BZKManager/updatePlayingNow(_:)``
- ``BZKManager/importListens(_:)``
- ``BZKManager/clearPlayingNow(onlyIfSubmittedByThisClient:)``
- ``BZKManager/deleteListen(listenedAt:recordingMSID:)``
- ``BZKListenSubmission``

### Reading Listens

- ``BZKManager/listens(forUser:before:after:count:)``
- ``BZKManager/listenCount(forUser:)``
- ``BZKManager/playingNow(forUser:)``
- ``BZKListens``
- ``BZKListen``
- ``BZKTrackMetadata``
- ``BZKAdditionalInfo``
- ``BZKMBIDMapping``
- ``BZKArtistCredit``
- ``BZKCoverArt``

### Feedback

- ``BZKManager/submitFeedback(_:for:)``
- ``BZKManager/feedback(forUser:score:count:offset:includeMetadata:)``
- ``BZKManager/feedback(forUser:recordings:)``
- ``BZKFeedbackScore``
- ``BZKRecordingIdentifier``
- ``BZKFeedback``
- ``BZKFeedbackPage``

### Pins

- ``BZKManager/pins(forUser:count:offset:)``
- ``BZKManager/currentPin(forUser:)``
- ``BZKManager/pinsFromFollowing(forUser:count:offset:)``
- ``BZKManager/pin(_:blurb:until:)``
- ``BZKManager/updatePin(id:blurb:)``
- ``BZKManager/unpin()``
- ``BZKManager/deletePin(id:)``
- ``BZKPinnedRecording``
- ``BZKPinnedRecordingPage``

### Playlists

- ``BZKManager/playlist(id:)``
- ``BZKManager/playlists(forUser:count:offset:)``
- ``BZKManager/playlists(createdFor:count:offset:)``
- ``BZKManager/collaborativePlaylists(forUser:count:offset:)``
- ``BZKManager/recommendedPlaylists(forUser:)``
- ``BZKManager/searchPlaylists(_:forUser:count:offset:)``
- ``BZKPlaylist``
- ``BZKPlaylistTrack``
- ``BZKPlaylistPage``

### Statistics

- ``BZKManager/topArtists(for:range:count:offset:)``
- ``BZKManager/topReleases(for:range:count:offset:)``
- ``BZKManager/topReleaseGroups(for:range:count:offset:)``
- ``BZKManager/topRecordings(for:range:count:offset:)``
- ``BZKManager/listeningActivity(for:range:)``
- ``BZKStatisticsScope``
- ``BZKStatisticsRange``
- ``BZKStatisticsPage``
- ``BZKStatisticsEntity``
- ``BZKArtistStatistic``
- ``BZKReleaseStatistic``
- ``BZKReleaseGroupStatistic``
- ``BZKRecordingStatistic``
- ``BZKListeningActivity``

### Popularity

- ``BZKManager/popularity(ofRecordings:)``
- ``BZKManager/popularity(ofArtists:)``
- ``BZKManager/popularity(ofReleases:)``
- ``BZKManager/popularity(ofReleaseGroups:)``
- ``BZKManager/topRecordings(forArtist:)``
- ``BZKManager/topReleaseGroups(forArtist:)``
- ``BZKPopularity``
- ``BZKArtistTopRecording``
- ``BZKArtistTopReleaseGroup``

### Users

- ``BZKManager/searchUsers(_:)``
- ``BZKManager/similarUsers(toUser:)``
- ``BZKManager/followers(ofUser:)``
- ``BZKManager/following(ofUser:)``
- ``BZKManager/follow(_:)``
- ``BZKManager/unfollow(_:)``
- ``BZKSimilarUser``

### Metadata

- ``BZKManager/lookupRecording(artist:track:release:)``
- ``BZKRecordingMatch``
- ``BZKManager/recordingMetadata(for:)``
- ``BZKManager/artistMetadata(for:)``
- ``BZKManager/releaseGroupMetadata(for:)``
- ``BZKManager/linkRecording(msid:toMBID:)``
- ``BZKManager/linkedRecording(forMSID:)``
- ``BZKRecordingMetadata``
- ``BZKArtistMetadata``
- ``BZKReleaseGroupMetadata``
- ``BZKMetadataRelease``
- ``BZKTag``
- ``BZKLink``

### Networking and Errors

- ``BZKHTTPClient``
- ``BZKError``
- ``BZKClientError``

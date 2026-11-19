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
- ``BZKManager/feedback(forRecording:score:count:offset:)``
- ``BZKFeedbackScore``
- ``BZKRecordingIdentifier``
- ``BZKFeedback``
- ``BZKFeedbackPage``

### Recommendations

- ``BZKManager/recommendedRecordings(forUser:count:offset:)``
- ``BZKManager/rateRecommendation(_:recordingMBID:)``
- ``BZKManager/removeRecommendationRating(recordingMBID:)``
- ``BZKManager/recommendationRatings(forUser:rating:count:offset:)``
- ``BZKManager/recommendationRatings(forUser:recordingMBIDs:)``
- ``BZKRecommendationPage``
- ``BZKRecommendedRecording``
- ``BZKRecommendationRating``
- ``BZKRecommendationFeedback``
- ``BZKRecommendationFeedbackPage``

### Explore

- ``BZKManager/freshReleases(days:around:sort:includePast:includeFuture:)``
- ``BZKManager/freshReleases(forUser:days:sort:includePast:includeFuture:)``
- ``BZKManager/releases(matchingColor:count:)``
- ``BZKManager/radio(prompt:mode:)``
- ``BZKManager/radioRecordings(forArtist:mode:maxSimilarArtists:maxRecordingsPerArtist:popularity:)``
- ``BZKManager/radioRecordings(forTags:matchAll:popularity:count:)``
- ``BZKFreshRelease``
- ``BZKFreshReleaseSort``
- ``BZKColorRelease``
- ``BZKRadioMode``
- ``BZKRadioPlaylist``
- ``BZKArtistRadioRecording``
- ``BZKTagRadioRecording``

### Pins

- ``BZKManager/pins(forUser:count:offset:)``
- ``BZKManager/currentPin(forUser:)``
- ``BZKManager/pin(id:)``
- ``BZKManager/pinsFromFollowing(forUser:count:offset:)``
- ``BZKManager/pin(_:blurb:until:)``
- ``BZKManager/updatePin(id:blurb:)``
- ``BZKManager/unpin()``
- ``BZKManager/deletePin(id:)``
- ``BZKPinnedRecording``
- ``BZKPinnedRecordingPage``

### Playlists

- ``BZKManager/playlist(id:includeTrackMetadata:)``
- ``BZKManager/playlists(forUser:count:offset:)``
- ``BZKManager/playlists(createdFor:count:offset:)``
- ``BZKManager/collaborativePlaylists(forUser:count:offset:)``
- ``BZKManager/recommendedPlaylists(forUser:)``
- ``BZKManager/searchPlaylists(_:forUser:count:offset:)``
- ``BZKManager/createPlaylist(title:description:isPublic:collaborators:recordingMBIDs:)``
- ``BZKManager/editPlaylist(id:title:description:isPublic:collaborators:)``
- ``BZKManager/addTracks(_:toPlaylist:at:)``
- ``BZKManager/moveTracks(inPlaylist:from:to:count:recordingMBID:)``
- ``BZKManager/removeTracks(fromPlaylist:at:count:)``
- ``BZKManager/copyPlaylist(id:)``
- ``BZKManager/deletePlaylist(id:)``
- ``BZKPlaylist``
- ``BZKPlaylistTrack``
- ``BZKPlaylistPage``

### Feed

- ``BZKManager/feedEvents(before:after:count:)``
- ``BZKManager/feedEvent(id:)``
- ``BZKManager/feedListensFromFollowing(before:after:count:)``
- ``BZKManager/feedListensFromSimilarUsers(before:after:count:)``
- ``BZKManager/recommendToFollowers(_:)``
- ``BZKManager/recommend(_:to:message:)``
- ``BZKManager/postReview(_:of:named:type:language:rating:)``
- ``BZKManager/hideFeedEvent(id:kind:)``
- ``BZKManager/unhideFeedEvent(id:kind:)``
- ``BZKManager/deleteFeedEvent(id:kind:)``
- ``BZKManager/thankFeedEvent(id:kind:message:)``
- ``BZKManager/postNotification(_:toUser:)``
- ``BZKFeedEvent``
- ``BZKFeedEventKind``
- ``BZKFeedEventContent``
- ``BZKFeedReview``
- ``BZKReviewEntityType``

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
- ``BZKManager/hourlyActivity(forUser:range:)``
- ``BZKManager/artistCountries(for:range:)``
- ``BZKManager/yearInMusic(forUser:year:)``
- ``BZKManager/archivedYearInMusic(forUser:year:)``
- ``BZKManager/artistActivity(for:range:)``
- ``BZKManager/artistEvolution(for:range:)``
- ``BZKManager/eraActivity(for:range:)``
- ``BZKManager/genreActivity(forUser:range:)``
- ``BZKManager/topListeners(ofArtist:range:)``
- ``BZKManager/topListeners(ofReleaseGroup:range:)``
- ``BZKManager/similarity(ofUser:to:)``
- ``BZKHourlyActivity``
- ``BZKWeekday``
- ``BZKCountryStatistic``
- ``BZKYearInMusic``
- ``BZKGenreShare``
- ``BZKTopListeners``
- ``BZKListener``
- ``BZKArtistActivity``
- ``BZKArtistActivityAlbum``
- ``BZKArtistEvolution``
- ``BZKEraActivity``
- ``BZKGenreActivity``

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

### Shareable Images

- ``BZKManager/statsArtURL(_:forUser:range:size:)``
- ``BZKManager/coverArtGridURL(forUser:range:dimension:layout:size:)``
- ``BZKManager/yearInMusicArtURL(_:forUser:year:)``
- ``BZKManager/coverArtGrid(releaseMBIDs:dimension:layout:size:background:showCaptions:)``
- ``BZKStatsArtDesign``
- ``BZKYearInMusicArt``
- ``BZKArtBackground``

### Account

- ``BZKManager/startDataExport(from:to:)``
- ``BZKManager/dataExports()``
- ``BZKManager/dataExport(id:)``
- ``BZKManager/downloadDataExport(id:)``
- ``BZKManager/deleteDataExport(id:)``
- ``BZKManager/connectedServices()``
- ``BZKManager/latestImport(forUser:service:)``
- ``BZKManager/setLatestImport(_:service:)``
- ``BZKDataExport``
- ``BZKDataExportStatus``

### Settings

- ``BZKManager/setTimeZone(_:)``
- ``BZKManager/setFlair(_:)``
- ``BZKManager/setExportsGeneratedPlaylistsToSpotify(_:)``
- ``BZKManager/setBrainzPlayerPreferences(_:)``
- ``BZKFlair``
- ``BZKBrainzPlayerPreferences``

### Service Status and Donors

- ``BZKManager/serviceStatus()``
- ``BZKManager/generatedPlaylistStatus()``
- ``BZKManager/recentDonors(count:offset:)``
- ``BZKManager/biggestDonors(count:offset:)``
- ``BZKManager/donorFlairs()``
- ``BZKServiceStatus``
- ``BZKDataAge``
- ``BZKDonor``
- ``BZKManager/dump(id:)``
- ``BZKDump``

### Networking and Errors

- ``BZKHTTPClient``
- ``BZKError``
- ``BZKClientError``

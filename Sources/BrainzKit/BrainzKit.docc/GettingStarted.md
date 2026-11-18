# Getting Started

Create a manager, sign a user in, and keep them signed in across launches.

## Identify your app

ListenBrainz asks every client to identify itself with a name, a version, and a way to contact its developer, and may block requests that don't. Describe your app with ``BZKClientInfo`` and create one ``BZKManager`` for your app's lifetime:

```swift
let manager = BZKManager(
    clientInfo: BZKClientInfo(name: "MyPlayer", version: "1.0", contact: "https://example.com")
)
```

## Sign a user in

ListenBrainz authenticates users with a personal token, which they copy from their [ListenBrainz settings page](https://listenbrainz.org/settings/). Pass it to ``BZKManager/signIn(token:)`` to validate it and remember the user:

```swift
do {
    let userName = try await manager.signIn(token: tokenFromUser)
    print("Signed in as \(userName)")
} catch BZKClientError.invalidToken {
    print("That token isn't valid.")
}
```

Store the token and user name securely, for example in the Keychain. On the next launch, restore them without a network request:

```swift
await manager.setToken(savedToken, userName: savedUserName)
```

Call ``BZKManager/signOut()`` to forget the user.

## Read public data

Listening history, statistics, feedback, and social data are public. These calls work without signing in, as long as you pass a user name:

```swift
let recent = try await manager.listens(forUser: "rob", count: 10)
let topArtists = try await manager.topArtists(for: .user("rob"), range: .thisMonth)
```

ListenBrainz calculates statistics periodically. Until it does, statistics calls throw ``BZKClientError/noContent``.

## Handle errors

Errors returned by ListenBrainz are thrown as ``BZKError``. ListenBrainz rate limits clients, so check ``BZKError/isRateLimited`` and wait ``BZKError/rateLimitResetIn`` seconds before retrying:

```swift
do {
    try await manager.submitListen(listen)
} catch let error as BZKError where error.isRateLimited {
    try await Task.sleep(for: .seconds(error.rateLimitResetIn ?? 1))
    try await manager.submitListen(listen)
}
```

Problems BrainzKit detects before sending a request, such as calling an action that needs a signed-in user, are thrown as ``BZKClientError``.

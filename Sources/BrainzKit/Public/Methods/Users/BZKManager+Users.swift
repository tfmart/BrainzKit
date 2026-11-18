//
//  BZKManager+Users.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Searches ListenBrainz users by name.
    ///
    /// - Parameter term: The text to search for.
    /// - Returns: The names of matching users.
    func searchUsers(_ term: String) async throws -> [String] {
        let request = BZKRequest(path: "search/users", queryItems: BZKRequest.query(["search_term": term]))
        let response: BZKUserSearchResponse = try await perform(request)
        return response.users.map(\.userName)
    }

    /// Fetches users whose listening taste is similar to a user's.
    ///
    /// - Parameter userName: The ListenBrainz user name.
    /// - Returns: Similar users, most similar first.
    func similarUsers(toUser userName: String) async throws -> [BZKSimilarUser] {
        let request = BZKRequest(path: "user/\(BZKRequest.segment(userName))/similar-users")
        let response: BZKPayloadResponse<[BZKSimilarUser]> = try await perform(request)
        return response.payload
    }

    /// Fetches the users who follow a user.
    ///
    /// - Parameter userName: The ListenBrainz user name.
    /// - Returns: The followers' names.
    func followers(ofUser userName: String) async throws -> [String] {
        let request = BZKRequest(path: "user/\(BZKRequest.segment(userName))/followers")
        let response: BZKFollowersResponse = try await perform(request)
        return response.followers
    }

    /// Fetches the users a user follows.
    ///
    /// - Parameter userName: The ListenBrainz user name.
    /// - Returns: The followed users' names.
    func following(ofUser userName: String) async throws -> [String] {
        let request = BZKRequest(path: "user/\(BZKRequest.segment(userName))/following")
        let response: BZKFollowingResponse = try await perform(request)
        return response.following
    }

    /// Makes the signed-in user follow another user.
    ///
    /// - Parameter userName: The user to follow.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func follow(_ userName: String) async throws {
        let request = try BZKRequest(method: .post, path: "user/\(BZKRequest.segment(userName))/follow", token: requiredToken())
        try await send(request)
    }

    /// Makes the signed-in user stop following another user.
    ///
    /// - Parameter userName: The user to unfollow.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func unfollow(_ userName: String) async throws {
        let request = try BZKRequest(method: .post, path: "user/\(BZKRequest.segment(userName))/unfollow", token: requiredToken())
        try await send(request)
    }
}

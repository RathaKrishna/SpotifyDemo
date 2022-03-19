//
//  PlaylistDeailsModel.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/18.
//

import Foundation

struct PlaylistDeailsModel: Codable {
    let description: String
    let external_urls: [String: String]
//    let followers:
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
    let primary_color: String
    let snapshot_id: String
    let tracks: PlaylistTracks
}
struct PlaylistTracks: Codable {
    let items: [PlaylistItems]
}
struct PlaylistItems: Codable {
    let added_at: String
    let track: PlaylistTrack
    
}
struct PlaylistTrack: Codable {
    let album: Album
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let name: String
    let type: String
    
}



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
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
    let tracks: PlaylistTracks
}
struct PlaylistTracks: Codable {
    let items: [PlaylistItems]
}
struct PlaylistItems: Codable {
    let track: AudioTrack
    
}




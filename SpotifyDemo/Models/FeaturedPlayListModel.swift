//
//  FeaturedPlayListModel.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/16.
//

import Foundation

struct FeaturedPlaylistModel: Codable {
    let message: String
    let playlists: PlayListResponse
}

struct PlayListResponse: Codable {
    let href: String
    let items: [Playlist]
}

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let href: String
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User

}
    
struct User: Codable {
    let display_name: String
    let id: String
    let external_urls: [String: String]
    let type: String
}
                
           

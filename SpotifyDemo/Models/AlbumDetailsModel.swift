//
//  AlbumDetailsModel.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/18.
//

import Foundation

struct AlbumDetailsModel: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
    
    
}

struct TracksResponse: Codable {
    let items: [AudioTrack]
    
}

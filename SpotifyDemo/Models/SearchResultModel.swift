//
//  SearchResultModel.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/22.
//

import Foundation

struct SearchResultModel: Codable {
    let albums: searchAlbumModel
    let artists: searchArtistsModel
    let playlists: searchPlaylistsModel
    let tracks: searchTracksModel
}

struct searchAlbumModel: Codable {
    let items: [Album]
}
struct searchArtistsModel: Codable {
    let items: [Artist]
}
struct searchPlaylistsModel: Codable {
    let items: [Playlist]
}
struct searchTracksModel: Codable {
    let items: [AudioTrack]
}

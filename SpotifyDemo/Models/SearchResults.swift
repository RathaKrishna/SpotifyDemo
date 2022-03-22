//
//  SearchResults.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/22.
//

import Foundation

enum SearchResults {
    case album(model: Album)
    case artist(model: Artist)
    case playlist(model: Playlist)
    case track(model: AudioTrack)
}

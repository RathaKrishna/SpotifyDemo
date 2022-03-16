//
//  Artist.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/10.
//

import Foundation


struct Artist: Codable {
    let href: String
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
 

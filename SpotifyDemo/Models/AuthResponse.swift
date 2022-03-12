//
//  AuthResponse.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/12.
//

import Foundation

//
struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}


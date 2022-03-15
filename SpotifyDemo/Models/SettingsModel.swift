//
//  SettingsModel.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/15.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}


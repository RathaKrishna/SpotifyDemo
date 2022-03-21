//
//  CategoriesModel.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/21.
//

import Foundation

struct CategoriesModel: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}
struct Category: Codable {
    let icons: [APIImage]
    let id: String
    let name: String
}

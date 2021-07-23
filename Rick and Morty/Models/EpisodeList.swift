//
//  Episodes.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 1.07.21.
//

import Foundation

struct PageInfo: Codable {
    let pages: Int
}

struct EpisodeList: Codable {
    let results: [Episode]
}

struct Episode: Codable {
    let name: String
    let episode: String
    let characters: [String]
}

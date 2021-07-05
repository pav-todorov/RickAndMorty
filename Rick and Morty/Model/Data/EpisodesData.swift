//
//  Episodes.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 1.07.21.
//

import Foundation

struct EpisodesData: Codable {
    
    let results:    [Results]
}

struct Results: Codable {
    let name:       String
    let episode:    String
    let characters: [String]
}

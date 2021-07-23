//
//  Characters.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 1.07.21.
//

import Foundation

struct Character: Codable {
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
}

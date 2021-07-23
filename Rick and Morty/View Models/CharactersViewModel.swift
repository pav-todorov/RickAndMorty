//
//  CharactersViewModel.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 21.07.21.
//

import Foundation

class CharactersViewModel {
    func addCharacter(for episode: Int, completion: @escaping (SingleCharacterViewModel) -> Void, episodesListViewModel:EpisodeListViewModel) {
        let charactersCount = episodesListViewModel.modelAt(episode).characters.count
        for index in 0..<charactersCount {
            guard let episodesURL = URL(string: episodesListViewModel.modelAt(episode).characters[index] ) else {
                fatalError("The character URL is wrong.")
            }
            let characterResource = Resource<Character>(url: episodesURL) { data in
                let characters = try? JSONDecoder().decode(Character.self, from: data)
                return characters
            }
            WebService().load(resource: characterResource) { (result) in
                if let characterResource = result {
                    completion(SingleCharacterViewModel(character: characterResource))
                }
            }
        }
    }
}

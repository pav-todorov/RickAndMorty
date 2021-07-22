//
//  EpisodesViewModel.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 20.07.21.
//

import Foundation

class EpisodeListViewModel {
    
    private var episodeViewModels = [SingleEpisodeViewModel]()
    
    func addEpisodeViewModel(_ vm: SingleEpisodeViewModel) {
        episodeViewModels.append(vm)
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return episodeViewModels.count
    }
    
    func modelAt(_ index: Int) -> SingleEpisodeViewModel {
        return episodeViewModels[index]
    }
    
    func getAllEpisodes() -> [String] {
        
        var arrayOfEpisodesToString = [String]()
        
        for episode in 0..<episodeViewModels.count {
            arrayOfEpisodesToString.append(episodeViewModels[episode].name)
        }
        
        return arrayOfEpisodesToString
    }
    
}

class SingleEpisodeViewModel {
    
    let singleEpisode: Episode
    
    init(episode: Episode) {
        self.singleEpisode = episode
    }
    
    var name: String {
        return singleEpisode.name
    }
    
    var episodeDigits: String {
        singleEpisode.episode
    }
    
    var characters: [String] {
        singleEpisode.characters
    }
    
}

class CharactersListViewModel {
    
    private var characterViewModels = [SingleCharacterViewModel]()
    
    func addCharacterViewModel(_ vm: SingleCharacterViewModel) {
        characterViewModels.append(vm)
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return characterViewModels.count
    }
    
    func modelAt(_ index: Int) -> SingleCharacterViewModel {
        return characterViewModels[index]
    }
    
    func getAllCharacters() -> [String] {
        
        var arrayOfCharactersToString = [String]()
        
        for character in 0..<characterViewModels.count {
            arrayOfCharactersToString.append(characterViewModels[character].name)
        }
        
        return arrayOfCharactersToString
    }
    
}

class SingleCharacterViewModel {
    let singleCharacter: Character
    
    init(character: Character) {
        self.singleCharacter = character
    }
    
    var name: String {
        return singleCharacter.name
    }
    
    var status: String {
        return singleCharacter.status
    }
    
    var species: String {
        return singleCharacter.species
    }
    
    var gender: String {
        return singleCharacter.gender
    }
    
    var imageURL: String {
        return singleCharacter.image
    }
    
}

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
    
    func getEpisodeNamed(_ nameOfEpisode: String) -> [SingleEpisodeViewModel] {
        
        let foundEpisode = episodeViewModels.filter {
            
            $0.name.lowercased().contains(nameOfEpisode.lowercased()) ||
                $0.episodeDigits.lowercased().contains(nameOfEpisode.lowercased())
            
        }
        
        return foundEpisode
        
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
    
    func getCharacterNamed(_ nameOfCharacter: String) -> [SingleCharacterViewModel] {
        
        let foundCharacter = characterViewModels.filter {
            
            $0.name.lowercased().contains(nameOfCharacter.lowercased())
            
        }
        
        return foundCharacter
        
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

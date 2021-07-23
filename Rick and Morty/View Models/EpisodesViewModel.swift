//
//  EpisodesViewModel.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 20.07.21.
//

import Foundation

class EpisodesViewModel {
    
    func addEpisode(completion: @escaping (SingleEpisodeViewModel) -> Void) {
        
        for index in 1..<3 {
            guard let episodesURL = URL(string: "https://rickandmortyapi.com/api/episode?page=\(index)") else {
                fatalError("Episode URL is wrong")
            }
            
            
            let episodeResource = Resource<EpisodeList>(url: episodesURL) { data in
                let episodes = try? JSONDecoder().decode(EpisodeList.self, from: data)
                                
                return episodes
            }
            
            WebService().load(resource: episodeResource) { (result) in
                if let episodeResource = result?.results {

                    episodeResource.map { completion(SingleEpisodeViewModel(episode: $0))
                        
                    }
                }
            }
            
        }
        
    }
    
}

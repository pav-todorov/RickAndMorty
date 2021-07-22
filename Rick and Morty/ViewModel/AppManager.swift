////
////  AppManager.swift
////  Rick and Morty
////
////  Created by Pavel Todorov on 1.07.21.
////
//
//import Foundation
//
//protocol AppManagerDelegate {
//    func didUpdateEpisodes(_ appManager: AppManager, episodes: [EpisodesModel])
//    func didUpdateCharacters(_ appManager: AppManager, characters: [CharactersModel])
//}
//
//class AppManager {
//    
//    init() {
//        get(K.episodes)
//    }
//    
//    let K = Constants()
//    
//    var delegate: AppManagerDelegate?
//    var characterURL: String = ""
//    var characterPictureURL: String = ""
//    var charactersFromEpisode: [String] = []
//    var episodeIndex = 0
//    var url = ""
//    
//    var episodes: [EpisodesModel] = [] {
//        didSet{
//            self.delegate?.didUpdateEpisodes(self, episodes: episodes)
//        }
//    }
//    
//    var characters: [CharactersModel] = [] {
//        didSet{
//            if(characters.count == charactersFromEpisode.count){
//                self.delegate?.didUpdateCharacters(self, characters: characters)
//            }
//        }
//    }
//    
//    
//    func get(_ request: String, for index: Int = 1) {
//        
//        // needs to be switch and enums
//        if(request == K.episodes){
//            url = K.episodesURL
//            
//        } else if request == K.characters {
//            
//            if(episodes[episodeIndex].characters.indices.contains(index)){
//                url = "\(episodes[episodeIndex].characters[index])"
//            }
//            
//        } else {
//            url = characterURL
//        }
//        
//        //1. Creating a URL
//        if let url = URL(string: url) {
//            
//            //2. Creating a URLSession
//            let session = URLSession(configuration: .default)
//            
//            //3. Giving the session a task
//            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
//                if error != nil{
//                    return
//                }
//                
//                if let safeData = data {
//                    self.parseJSON(safeData, for: request)
//                    
//                }
//            })
//            
//            //4. Start the task
//            task.resume()
//        }
//    }
//    
//    func parseJSON(_ JSONData: Data, for entity: String, with index: Int = 1) {
//        let decoder = JSONDecoder()
//        
//        if(entity == K.episodes){
//            do {
//                let decodedData = try decoder.decode(EpisodeList.self, from: JSONData)
//                for index in 0..<20 {
//                    episodes.append(EpisodesModel(name:         decodedData.results[index].name,
//                                                  episode:      decodedData.results[index].episode,
//                                                  characters:   decodedData.results[index].characters)
//                    )
//                }
//                charactersFromEpisode = episodes[episodeIndex].characters
//                
//                
//            } catch {
//                print(error)
//            }
//            
//        } else if (entity == K.characters) {
//            do {
//                let decodedData = try decoder.decode(Character.self, from: JSONData)
//                
//                characters.append(CharactersModel(name:     decodedData.name,
//                                                  status:   decodedData.status,
//                                                  species:  decodedData.species,
//                                                  gender:   decodedData.gender,
//                                                  image:    decodedData.image)
//                )
//                
//                
//            } catch {
//                print(error)
//            }
//        }
//    }
//    
//    func getEpisodeName(for index: Int) -> String? {
//        
//        if (episodes.count != 0){
//            return episodes[index].name
//        } else {
//            return nil
//        }
//    }
//    
//    func getCountOfCharacters(for index: Int) -> Int {
//        if (episodes.count != 0){
//            return episodes[index].characters.count
//        } else {
//            return 0
//        }
//    }
//    
//    func getNumberOfEpisodes() -> Int {
//        return episodes.count
//    }
//    
//    func getEpisodeDigits(for index: Int) -> String {
//        if (!episodes.isEmpty){
//            
//            return episodes[index].episode
//        } else {
//            return "oops"
//        }
//    }
//    
//    func getCharacterImage(for index: Int, and episode: Int = 0) -> String {
//        if (!characters.isEmpty){
//            episodeIndex = episode
//            
//            for index in 0..<charactersFromEpisode.count {
//                get(K.characters, for: index)
//
//            }
//            
//            return characters[index].image
//        } else {
//            return ""
//        }
//    }
//    
//    func getCharacterName(for index: Int) -> String {
//        get(K.characters, for: index)
//        
//        if (!characters.isEmpty){
//            
//            return characters[index].name
//        } else {
//            return ""
//        }
//    }
//    
//    func getCharacterSpecies(for index: Int) -> String {
//        get(K.characters, for: index)
//        
//        if (!characters.isEmpty){
//            
//            return characters[index].species
//        } else {
//            return ""
//        }
//    }
//    
//    func getCharacterStatus(for index: Int) -> String {
//        get(K.characters, for: index)
//        
//        if (!characters.isEmpty){
//            
//            return characters[index].status
//        } else {
//            return ""
//        }
//    }
//    
//    func getCharacterGender(for index: Int) -> String {
//        get(K.characters, for: index)
//        
//        if (!characters.isEmpty){
//            
//            return characters[index].gender
//        } else {
//            return ""
//        }
//    }
//    
//    //    func getStringOfCharacters() -> [String] {
//    //        get("character")
//    //        
//    //        if (!characters.isEmpty){
//    //            
//    //            var charactersString: [String] = [""]
//    //            
//    //            for index in 0..<characters.count {
//    //                charactersString.append(characters[index].name)
//    //            }
//    //            
//    //            return charactersString
//    //        } else {
//    //            return [""]
//    //        }
//    //    }
//    
//    //    func getEpisodesData() -> [String] {
//    //        var episodesNames: [String] = ["oops"]
//    //
//    //        print("the episodes \(episodes)")
//    //        for index in 0..<episodes.count{
//    //            episodesNames.append(self.episodes[index].name)
//    //        }
//    //        
//    //        return episodesNames
//    //    }
//}

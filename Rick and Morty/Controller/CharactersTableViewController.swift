//
//  CharactersTableViewController.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 1.07.21.
//

import UIKit
import SDWebImage

class CharactersTableViewController: UITableViewController {
    
    let K = Constants()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let appManager = AppManager()
    var rowIndexFromEpisodes: Int? = nil
    var selectedRow: Int?
    
    var filteredCharacters: [String] = []
    
    var characters: [String] = [""]
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = K.charactersSearchBarText
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        //        characters = appManager.getStringOfCharacters()
        
        var isSearchBarEmpty: Bool {
            return searchController.searchBar.text?.isEmpty ?? true
        }
        
        self.appManager.delegate = self
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = appManager.getCountOfCharacters(for: rowIndexFromEpisodes!)
        
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.characterCell, for: indexPath)
        
        let imageURL = appManager.getCharacterImage(for: indexPath.row, and: rowIndexFromEpisodes!)
        
        cell.imageView?.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: K.placeHolderImage))
        
        cell.textLabel?.text = appManager.getCharacterName(for: indexPath.row)
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: K.segueToSingleCharacter, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == K.segueToSingleCharacter){
            let destinationVC = segue.destination as! SingleCharacterViewController
            destinationVC.characterIndex = selectedRow
            destinationVC.rowIndex = self.rowIndexFromEpisodes
            destinationVC.appManager = self.appManager
        }
    }
}

extension CharactersTableViewController: AppManagerDelegate {
    func didUpdateEpisodes(_ appManager: AppManager, episodes: [EpisodesModel]) {
        
    }
    
    func didUpdateCharacters(_ appManager: AppManager, characters: [CharactersModel]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension CharactersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCharacters = characters.filter { (characters: String) -> Bool in
            print(" printing characters : \(characters)")
            return characters.lowercased().contains(searchText.lowercased())
            
        }
        
        tableView.reloadData()
        
    }
}

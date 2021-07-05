//
//  EpisodesViewController.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 1.07.21.
//

import UIKit

class EpisodesViewController: UITableViewController {
    
    let K = Constants()
    
    var rowIndex: Int = 0
    var numberOfRows: Int?
    let appManager = AppManager()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredEpisodes: [String] = []
    var episodes: [String] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var episodesSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = K.episodesSearchBarText
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        var isSearchBarEmpty: Bool {
            return searchController.searchBar.text?.isEmpty ?? true
        }
        
        appManager.delegate = self

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredEpisodes.count
        }
        
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.episodeCell, for: indexPath)
        
        let episodeDigits = appManager.getEpisodeDigits(for: indexPath.row)
        var episodeName = appManager.getEpisodeName(for: indexPath.row)
        
        episodes.append(episodeName ?? "oops")
        
        if isFiltering {
            episodeName = filteredEpisodes[indexPath.row]
        }
        
        if (episodeName != nil){
            cell.textLabel?.text = "\(episodeDigits) \(episodeName!)"
        }
        
        cell.imageView?.image = UIImage(named: K.placeHolderImage)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowIndex = indexPath.row
        performSegue(withIdentifier: K.segueToCharacters, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == K.segueToCharacters){
            let destinationVC = segue.destination as! CharactersTableViewController
            destinationVC.rowIndexFromEpisodes = rowIndex
        }
    }
}

extension EpisodesViewController: AppManagerDelegate {
    func didUpdateEpisodes(_ appManager: AppManager, episodes: [EpisodesModel]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didUpdateCharacters(_ appManager: AppManager, characters: [CharactersModel]) {
        
    }
}

extension EpisodesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredEpisodes = episodes.filter { (episodes: String) -> Bool in
            print(" printing episodes : \(episodes)")
            return episodes.lowercased().contains(searchText.lowercased())
            
        }
        
        tableView.reloadData()
    }
}

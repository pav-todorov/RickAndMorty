//
//  CharactersTableViewController.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 1.07.21.
//

import UIKit
import SDWebImage

class CharactersTableViewController: UITableViewController {
    private var episodesViewController = EpisodesViewController()
    private var charactersListViewModel = CharactersListViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var rowIndexFromEpisodes: Int?
    private var selectedRow: Int?
    private var filteredCharacters: [SingleCharacterViewModel] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EpisodesViewController.delegate = self
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = K().charactersSearchBarText
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        searchController.searchBar.searchTextField.textColor = .white
        var isSearchBarEmpty: Bool {
            return searchController.searchBar.text?.isEmpty ?? true
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCharacters.count
        }
        return charactersListViewModel.numberOfRows(section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K().characterCell, for: indexPath)
        cell.textLabel!.numberOfLines = 0
        if isFiltering {
            cell.textLabel?.text = filteredCharacters[indexPath.row].name
            cell.imageView?.sd_setImage(with: URL(string: filteredCharacters[indexPath.row].imageURL), placeholderImage: UIImage(named: K().placeHolderImage))

            return cell
        } else {
            cell.imageView?.sd_setImage(with: URL(string: charactersListViewModel.modelAt(indexPath.row).imageURL), placeholderImage: UIImage(named: K().placeHolderImage))
            cell.textLabel?.text = charactersListViewModel.modelAt(indexPath.row).name
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        performSegue(withIdentifier: K().segueToSingleCharacter, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == K().segueToSingleCharacter){
            let destinationVC = segue.destination as? SingleCharacterViewController
            if !isFiltering {
                destinationVC!.singleCharacter = charactersListViewModel.modelAt(selectedRow!)
            } else {
                destinationVC!.singleCharacter = filteredCharacters[selectedRow!]
            }
            
        }
    }
}

// MARK: - UISearchResultsUpdating

extension CharactersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    func filterContentForSearchText(_ searchText: String) {
        
        filteredCharacters = charactersListViewModel.getCharacterNamed(searchText)
        
        tableView.reloadData()
    }
}

// MARK: - EpisodesDelegate

extension CharactersTableViewController: EpisodesDelegate {
    func episodesDidLoad(vm: SingleCharacterViewModel) {
        charactersListViewModel.addCharacterViewModel(vm)
        self.tableView.reloadData()
    }
}

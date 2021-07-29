//
//  EpisodesViewController.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 1.07.21.
//

import UIKit

protocol EpisodesDelegate {
    func episodesDidLoad(vm: SingleCharacterViewModel)
}

class EpisodesViewController: UITableViewController {
    func finishedLoading() {
        self.tableView.reloadData()
    }
    
    static var delegate: EpisodesDelegate?
    private var episodesListViewModel = EpisodeListViewModel()
    private var episodeVM = EpisodesViewModel()
    
    private var charactersViewModel = CharactersViewModel()
    private var characterListVM = CharactersListViewModel()
    var rowIndex: Int = 0

    let searchController = UISearchController(searchResultsController: nil)
    var filteredEpisodes: [SingleEpisodeViewModel] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var episodesSearchBar: UISearchBar!
    var webService: WebService?
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Episodes"
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "get schwifty", size: 20)!]

        
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = K().episodesSearchBarText
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true

        searchController.searchBar.searchTextField.textColor = .white
        var isSearchBarEmpty: Bool {
            return searchController.searchBar.text?.isEmpty ?? true
        }
        episodeVM.addEpisode() { (vm) in

            self.episodesListViewModel.addEpisodeViewModel(vm)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredEpisodes.count
        }
        return episodesListViewModel.numberOfRows(section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K().episodeCell, for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = .byWordWrapping
        cell.imageView?.image = UIImage(named: K().placeHolderImage)
        
        if isFiltering {
            
            cell.textLabel?.text = filteredEpisodes[indexPath.row].episodeDigits + " " + filteredEpisodes[indexPath.row].name
                return cell
        } else {
            
        let episodeListVM = episodesListViewModel.modelAt(indexPath.row)
        cell.textLabel?.text = "\(episodeListVM.episodeDigits)  \(episodeListVM.name)"
    
        return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowIndex = indexPath.row
        
        if !isFiltering {
            
            charactersViewModel.addCharacter(for: indexPath.row, completion: { vm in
                EpisodesViewController.delegate?.episodesDidLoad(vm: vm)
            }, episodesListViewModel: self.episodesListViewModel)
            performSegue(withIdentifier: K().segueToCharacters, sender: self)
            
        } else {
            
            charactersViewModel.addCharactersFromFiltering(completion: { vm in
                EpisodesViewController.delegate?.episodesDidLoad(vm: vm)
            }, episode: self.filteredEpisodes[indexPath.row])
            
            performSegue(withIdentifier: K().segueToCharacters, sender: self)
        }
        
        

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K().segueToCharacters {
            _ = segue.destination as? CharactersTableViewController
        }
    }
}

extension EpisodesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    func filterContentForSearchText(_ searchText: String) {
    
        filteredEpisodes = episodesListViewModel.getEpisodeNamed(searchText)

        tableView.reloadData()
    }
}

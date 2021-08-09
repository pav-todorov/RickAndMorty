//
//  EpisodesTableViewController.swift
//  Rick and Morty MVVM and RxSwift
//
//  Created by Pavel Todorov on 4.08.21.
//

import UIKit
import RxSwift
import RxCocoa

class EpisodesTableViewController: UITableViewController, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    
    let disposeBag = DisposeBag()
    
    var foundEpisode = BehaviorRelay<[EpisodeViewModel]>(value: [])
    
    let episodesFromViewModel = BehaviorRelay<[EpisodeViewModel]>(value: [])
    
    private var episodeListViewModel = BehaviorRelay<EpisodeListViewModel>(value: EpisodeListViewModel())
    
    private let selectedEpisode = PublishSubject<EpisodeViewModel>()
    
//    var selectedEpisodeSubjectObservable: Observable<EpisodeViewModel> {
//        return selectedEpisode.asObservable()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        populateEpisodes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = nil

        //MARK: - Setting the search bar
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search a character"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
       
        Observable.combineLatest(episodesFromViewModel, foundEpisode){ (initialEpisodes, filteredEpisodes) -> [EpisodeViewModel] in
            if self.isFiltering {
                return filteredEpisodes
            } else {
                return initialEpisodes
            }

        }.bind(to: tableView.rx.items(cellIdentifier: "EpisodeTableViewCell")) { [unowned self] index, model, cell in
            
            cell.imageView?.image = UIImage(named: "icon")
            cell.accessoryType = .disclosureIndicator
            cell.textLabel!.numberOfLines = 0
            cell.imageView?.layer.shadowColor = UIColor.gray.cgColor
            cell.imageView?.layer.shadowOpacity = 0.5
            cell.imageView?.layer.shadowOffset = .zero
            cell.imageView?.layer.shadowRadius = 5
            cell.textLabel?.text = model.episodeName


        }.disposed(by: disposeBag)

        
        tableView.rx.modelSelected(EpisodeViewModel.self)
            .subscribe(onNext: { [weak self] model in
                
                guard let strongSelf = self else { return }
                
                guard let characterTVC = strongSelf.storyboard?.instantiateViewController(identifier: "CharactersTableViewController") as? CharactersTableViewController else {
                    fatalError("CharactersTableViewController not found")
                }
                                
                characterTVC.receivedEpisode.accept(model)
                                
                strongSelf.navigationController?.pushViewController(characterTVC, animated: true)
                
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Table view data source
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.episodeListViewModel.episodesVM.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath)
//
//        let episodeVM = self.episodeListViewModel.episodeAt(indexPath.row)
//
//        episodeVM.episodeName.asDriver(onErrorJustReturn: "Error retrieving data")
//            .drive((cell.textLabel?.rx.text)!)
//            .disposed(by: disposeBag)
//
//        cell.imageView?.image = UIImage(named: "icon")
//
//        cell.accessoryType = .disclosureIndicator
//        cell.textLabel!.numberOfLines = 0
//
//
//        return cell
//    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.selectedEpisode.onNext(episodeListViewModel.episodeAt(indexPath.row))
//
//        self.indexOfSelectedEpisode = indexPath.row
//
//        self.performSegue(withIdentifier: "SegueToCharacters", sender: self)
//
//    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let charactersVC = segue.destination as? CharactersTableViewController
        
//        charactersVC?.receivedEpisode.accept(self.episodeListViewModel.episodeAt(self.indexOfSelectedEpisode))
    }
    var episodeListViewModelObject = EpisodeListViewModel()
    
    private func populateEpisodes() {
        
        for index in 1..<4 {
            
            let resource = Resource<EpisodeList>(url: URL(string: "https://rickandmortyapi.com/api/episode?page=\(index)")!)
            
            URLRequest.load(resource: resource)
                .subscribe(onNext: { episodeList in
                    
                    let episodes = episodeList.results
//                    self.episodeListViewModel.addEpisodes(episodes)
                    
                    self.episodeListViewModelObject.addEpisodes(episodes)
                    
                    self.episodeListViewModel.accept(self.episodeListViewModelObject)
                    
                    
                    
                    self.episodesFromViewModel.accept(self.episodeListViewModelObject.getAllEpisodes())
                                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }).disposed(by: disposeBag)
            
        }
        
    }
    
}

//
//  CharactersTableViewController.swift
//  Rick and Morty MVVM and RxSwift
//
//  Created by Pavel Todorov on 4.08.21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SDWebImage
import Nuke
import RxAnimated
import RxNuke


class CharactersTableViewController: UITableViewController, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var foundCharacter = BehaviorRelay<[Character]>(value: [])
    
    let options = ImageLoadingOptions(
        placeholder: UIImage(named: "icon"),
        transition: .fadeIn(duration: 0.33))
    
    
    private let disposeBag = DisposeBag()
    var episodeViewModel = BehaviorRelay<EpisodeViewModel?>(value: nil)
    var receivedEpisode = BehaviorRelay<EpisodeViewModel?>(value: nil)
    
    var characterObject = BehaviorRelay<[Character]>(value: [])
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateCharacters()
        
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
        
        searchController.searchBar.searchTextField.textColor = .white

        
        // MARK: - Table view data
        
//        tableView.rx.willDisplayCell.subscribe(onNext: { cell in
//
//            Nuke.loadImage(with: ImageRequest(url: URL(string: model.image)!, processors: [
//                ImageProcessors.Circle(border: ImageProcessingOptions.Border(color: .white, width: 20, unit: .points)), ImageProcessors.Resize(size: (cell.imageView?.bounds.size)!)
//
//            ]), options: self.options, into: cell.imageView!)
//
//
//        })
        
        Observable.combineLatest(characterObject, foundCharacter){ (initialCharacters, filteredCharacters) -> [Character] in
            if self.isFiltering {
                return filteredCharacters
            } else {
                return initialCharacters
            }
            
        }.bind(to: tableView.rx.items(cellIdentifier: "CharacterTableViewCell")) { [unowned self] index, model, cell in
            
                        
                Nuke.loadImage(with: ImageRequest(url: URL(string: model.image)!, processors: [
                    ImageProcessors.Circle(border: ImageProcessingOptions.Border(color: .white, width: 20, unit: .points)), ImageProcessors.Resize(size: (cell.imageView?.bounds.size)!)

                ]), options: self.options, into: cell.imageView!)

            cell.accessoryType = .disclosureIndicator
            cell.textLabel!.numberOfLines = 0
            cell.imageView?.layer.shadowColor = UIColor.gray.cgColor
            cell.imageView?.layer.shadowOpacity = 0.5
            cell.imageView?.layer.shadowOffset = .zero
            cell.imageView?.layer.shadowRadius = 5
            cell.textLabel?.text = model.name
            
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                
                self!.tableView.deselectRow(at: indexPath, animated: true)
                
            }).disposed(by: disposeBag)
        
        
        // MARK: - Selecting a row
        
        tableView.rx.modelSelected(Character.self)
            .subscribe(onNext: { [weak self] model in
                
                guard let strongSelf = self else { return }
                
                guard let singleCharacterVC = strongSelf.storyboard?.instantiateViewController(identifier: "SingleCharacterViewController") as? SingleCharacterViewController else {
                    fatalError("SingleCharacterViewController not found")
                }
                
                singleCharacterVC.receivedCharacter.accept(model)
                
                strongSelf.navigationController?.showDetailViewController(singleCharacterVC, sender: self)
                
            }).disposed(by: disposeBag)
        
        //MARK: - Searching through characters
        
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: {query in
                self.foundCharacter.accept(self.characterObject.value.filter {
                    
                    $0.name.lowercased().contains(query.lowercased())
                    
                })
            }).disposed(by: disposeBag)
        
    }
    
    /// Gets characters from the URLs that have been passed by the EpisodeTableViewController
    private func populateCharacters() {
        
        receivedEpisode.subscribe(onNext: { episodeViewModel in
            
            if let episodeViewModel = episodeViewModel{
                
                let array = episodeViewModel.episodeCharacters
                
                array.subscribe(onNext: { linksArray in
                    linksArray.compactMap { charactersLink in
                        
                        let resource = Resource<Character>(url: URL(string: charactersLink)!)
                        
                        URLRequest.load(resource: resource)
                            .subscribe(onNext: { [self] character in
                                
                                self.characterObject.accept(characterObject.value + [character])
                                
                            }).disposed(by: self.disposeBag)
                    }
                }).disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
        
    }
    
}

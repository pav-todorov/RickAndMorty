//
//  SingleCharacterViewController.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 2.07.21.
//

import UIKit
import SDWebImage

class SingleCharacterViewController: UIViewController {
    
    let K = Constants()
    
    var characterIndex: Int?
    var rowIndex: Int?
    var appManager: AppManager?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appManager!.get(K.episodes)
        
        let URLString = appManager!.getCharacterImage(for: characterIndex!, and: rowIndex!)
        
        imageView.sd_setImage(with: URL(string: URLString), placeholderImage: UIImage(named: K.placeHolderImage))
        nameLabel.text =    appManager?.getCharacterName(for: characterIndex!)
        statusLabel.text =  appManager?.getCharacterStatus(for: characterIndex!)
        speciesLabel.text = appManager?.getCharacterSpecies(for: characterIndex!)
        genderLabel.text =  appManager?.getCharacterGender(for: characterIndex!)
        
    }
}

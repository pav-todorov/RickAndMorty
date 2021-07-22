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
    
    var singleCharacter: SingleCharacterViewModel!
    
    var characterIndex: Int?
    var rowIndex: Int?
//    var appManager: AppManager?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        guard let font = UIFont(name: "get schwifty", size: 34) else {
            fatalError("custom font not found")
        }
        
//        nameLabel.text = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 54/255, green: 164/255, blue: 193/255, alpha: 1.0),
//                     NSAttributedString.Key.strokeColor : UIColor(displayP3Red: 202/255, green: 215/255, blue: 85/255, alpha: 1.0),
//                     NSAttributedString.Key.strokeWidth : -2.0,
//                     NSAttributedString.Key.font : font]
        
        nameLabel.font = font
        nameLabel.textColor = UIColor(displayP3Red: 54/255, green: 164/255, blue: 193/255, alpha: 1.0)
        nameLabel.shadowColor = UIColor(displayP3Red: 202/255, green: 215/255, blue: 85/255, alpha: 1.0)
        nameLabel.lineBreakMode = .byClipping
        nameLabel.numberOfLines = 0

        
        
//        nameLabel.text = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 54/255, green: 164/255, blue: 193/255, alpha: 1.0),
//                     NSAttributedString.Key.strokeColor : UIColor(displayP3Red: 202/255, green: 215/255, blue: 85/255, alpha: 1.0),
//                     NSAttributedString.Key.strokeWidth : -2.0,
//                     NSAttributedString.Key.font : font]

        let URLString = singleCharacter.imageURL
        let characterName = singleCharacter.name
        let characterStatus = singleCharacter.status
        let characterSpecies = singleCharacter.species
        let characterGender = singleCharacter.gender

        imageView.sd_setImage(with: URL(string: URLString), placeholderImage: UIImage(named: K.placeHolderImage))
        nameLabel.text =    characterName
        statusLabel.text =  characterStatus
        speciesLabel.text = characterSpecies
//        genderLabel.font = font
        genderLabel.text =  characterGender
        
    }
}

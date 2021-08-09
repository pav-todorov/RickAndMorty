//
//  SingleCharacterViewController.swift
//  Rick and Morty MVVM and RxSwift
//
//  Created by Pavel on 7.08.21.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage
import Nuke

class SingleCharacterViewController: UIViewController {
    
    var receivedCharacter = BehaviorRelay<Character?>(value: nil)
    let disposeBag = DisposeBag()
    
    let options = ImageLoadingOptions(
        placeholder: UIImage(named: "icon"),
        transition: .fadeIn(duration: 0.33))

    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: ExpandedLabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterNameLabel.adjustsFontSizeToFitWidth = true
        guard let font = UIFont(name: "get schwifty", size: 40) else {
            fatalError("Custom font not found.")
        }
        
        characterNameLabel.font = font
        characterNameLabel.textColor = UIColor(displayP3Red: 54/255, green: 164/255, blue: 193/255, alpha: 1.0)
        characterNameLabel.shadowColor = UIColor(displayP3Red: 202/255, green: 215/255, blue: 85/255, alpha: 1.0)
        characterNameLabel.numberOfLines = 0
        
        characterImageView?.layer.shadowColor = UIColor.white.cgColor
        characterImageView?.layer.shadowOpacity = 0.5
        characterImageView?.layer.shadowOffset = .zero
        characterImageView?.layer.shadowRadius = 5
        
        receivedCharacter.subscribe { characterModel in
            
            Nuke.loadImage(with: ImageRequest(url: URL(string: characterModel!.image)!, processors: [
                ImageProcessors.Circle(border: ImageProcessingOptions.Border(color: .white, width: 10, unit: .points))
            ]), options: self.options, into: self.characterImageView)
            
        }.disposed(by: disposeBag)
        
        receivedCharacter.map { $0?.name }.bind(to: self.characterNameLabel.rx.text).disposed(by: disposeBag)
        receivedCharacter.map { $0?.status }.bind(to: self.statusLabel.rx.text).disposed(by: disposeBag)
        receivedCharacter.map { $0?.species }.bind(to: self.speciesLabel.rx.text).disposed(by: disposeBag)
        receivedCharacter.map { $0?.gender }.bind(to: self.genderLabel.rx.text).disposed(by: disposeBag)
        
    }
    
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

}

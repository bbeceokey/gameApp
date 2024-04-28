//
//  CollectionViewCell.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 26.04.2024.
//

import UIKit
import Kingfisher
class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gameDetails: UILabel!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(_ model : Game) {
        
        gameName.text = model.name
        let imageURL = URL(string: model.backgroundImage)
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: imageURL)
        gameDetails.text = "\(model.rating) - \(model.released)"
    }

}

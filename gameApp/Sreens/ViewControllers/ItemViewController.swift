//
//  ItemViewController.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 25.04.2024.
//

import UIKit
import Kingfisher

class ItemViewController: UIViewController {
    var itemIndex: Int = 0
    var game: Game?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageViewTapGesture()
        guard let game = game else {
            return
        }
        
        imageController(game)
    }
    
    func setupImageViewTapGesture() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
           imageView.isUserInteractionEnabled = true
           imageView.addGestureRecognizer(tapGesture)
       }
       
       @objc func imageViewTapped() {
           performSegue(withIdentifier: "showDetail", sender: self)
       }
       

       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "showDetail" {
               if let destinationVC = segue.destination as? DetailViewController {
                   destinationVC.game = game!
               }
           }
       }
       
    func imageController(_ model: Game) {
        guard let imageURL = URL(string: model.backgroundImage), !model.backgroundImage.isEmpty else {
            return
        }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageURL, placeholder: nil, options: [], progressBlock: nil)
    }
}

//
//  DetailViewController.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 26.04.2024.
//

import UIKit
import Kingfisher

final class DetailViewController: UIViewController  {

    var game : Game?
    var gameDetails : GameDetail?

    @IBOutlet weak var addFavoriBtn: UIButton!
    
    @IBOutlet weak var gameRelease: UILabel!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var labelStackView: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var detailsText: UITextView!
    
    
    let favoriteManager = FavoriteManager.shared
        
        override func viewDidLoad() {
            super.viewDidLoad()
            updateFavoriteButton()
            
            let id = game?.id
        }
        
        @IBAction func addedFAvori(_ sender: Any) {
   
            toggleFavorite()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            GameLogic.shared.getGameDetails(for: game!.id) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let gameDetails):
                    self.gameDetails = gameDetails
                    DispatchQueue.main.async {
                        self.setValue(gameDetails)
                    }
                    print("------- GAMES DETAILS ------ ", gameDetails)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        private func setValue(_ model : GameDetail) {
            gameName.text = model.name
            gameRelease.text = model.released
            let imageURL = URL(string: model.backgroundImage)
            gameImage.kf.indicatorType = .activity
            gameImage.kf.setImage(with: imageURL)
            detailsText.isEditable = false
            detailsText.text = model.description
            detailsText.isHidden = false
        }
        
        private func toggleFavorite() {
            guard let game = game else { return }
            // Favori butonuna tıklandığında favori durumunu değiştirin
            if favoriteManager.isFavorite(game.id) {
                favoriteManager.removeFromFavorites(game.id)
            } else {
                favoriteManager.addToFavorites(game.id)
            }
            updateFavoriteButton()
        }
        
        private func updateFavoriteButton() {
            guard let game = game else { return }
            // Favori butonunun görünümünü güncelleyin
            let isFavorite = favoriteManager.isFavorite(game.id)
            let imageName = isFavorite ? "heart.fill" : "heart"
            addFavoriBtn.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }

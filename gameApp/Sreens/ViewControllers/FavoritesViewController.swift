//
//  FavoritesViewController.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 27.04.2024.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    var favouritesGame = [Game]()
    var filteredGames = [Game]()
    var isFiltering : Bool = false
    let favoriteManager = FavoriteManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isUserInteractionEnabled = true
        searchBar.delegate = self
       
        collectionViewSet()
        favouritesCollectionView.collectionViewLayout = flowLayoutSet()
        
        view.addSubview(noDataLabel)
        setupNoDataLabelConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionViewSet()
        favouritesCollectionView.collectionViewLayout = flowLayoutSet()
        favouritesListUpdate()
    }
    
    //TODO:
    private func favouritesListUpdate() {
        favouritesGame.removeAll()
        let favouritesGameIndexs = favoriteManager.fetchFavorites()
            for favoriteId in favouritesGameIndexs {
                if let favoriteGame = gameLists.first(where: { $0.id == favoriteId }) {
                    favouritesGame.append(favoriteGame)
                } }
        favouritesCollectionView.reloadData()
    }
    
    private var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No Favori Game"
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupNoDataLabelConstraints() {
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func flowLayoutSet() -> UICollectionViewFlowLayout{
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        //let flowHeight = UIScreen.main.bounds.height
        let flowWidth = UIScreen.main.bounds.width
        flowLayout.itemSize = CGSize(width: flowWidth, height: 70)
        flowLayout.minimumLineSpacing = 50
        flowLayout.minimumInteritemSpacing = 50
        return flowLayout
        
    }
    
    private func collectionViewSet() {
        favouritesCollectionView.dataSource = self
        favouritesCollectionView.delegate = self
        favouritesCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectiongameCell")
    }

}

extension FavoritesViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
                noDataLabel.isHidden = filteredGames.count > 0
                return filteredGames.count
            } else {
                noDataLabel.isHidden = gameLists.count > 0
                return favouritesGame.count
            }
        
    }
    
   
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectiongameCell", for: indexPath) as! CollectionViewCell
        if isFiltering {
            cell.configCell(filteredGames[indexPath.row])
        }else
        {
            cell.configCell(favouritesGame[indexPath.row])
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFiltering {
            let selectedItem = filteredGames[indexPath.item]
            if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
                    detailViewController.game = selectedItem
                    navigationController?.pushViewController(detailViewController, animated: true)
                }
        } else {
            let selectedItem = favouritesGame[indexPath.item]
            if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
                    detailViewController.game = selectedItem
                    navigationController?.pushViewController(detailViewController, animated: true)
                }
        }
       
    }
    

}


extension FavoritesViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
                    filteredGames = favouritesGame.filter { game in
                        return game.name.lowercased().contains(searchText.lowercased())
                    }
                } else {
                    filteredGames = favouritesGame
                }
                isFiltering = true
                favouritesCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
        searchBar.text = ""
        filteredGames = [Game]()
        favouritesCollectionView.reloadData()
    }
}
 

//
//  File.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 28.04.2024.
//

import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    private let favoritesKey = "favorites"
    
    // Favori oyunları saklamak için Set kullanıyoruz
    private var favorites: Set<Int> = []
    
    private init() {
        // UserDefaults'tan favori oyunları yükle
        if let savedFavorites = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
            favorites = Set(savedFavorites)
        }
    }
    
    // Bir oyunun favori olup olmadığını kontrol etmek için
    func isFavorite(_ gameId: Int) -> Bool {
        return favorites.contains(gameId)
    }
    
    // Bir oyunu favorilere ekle
    func addToFavorites(_ gameId: Int) {
        favorites.insert(gameId)
        saveFavorites()
    }
    
    // Bir oyunu favorilerden çıkar
    func removeFromFavorites(_ gameId: Int) {
        favorites.remove(gameId)
        saveFavorites()
    }
    
    // Favori oyunları UserDefaults'a kaydet
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }
    func fetchFavorites() -> [Int]{
        return UserDefaults.standard.array(forKey: favoritesKey) as! [Int] 
    }
}

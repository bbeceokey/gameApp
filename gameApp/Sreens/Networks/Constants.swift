//
//  Constants.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 25.04.2024.
//
//TODO: detail urli ayarlanıcak aradaki id yi nasıl eklicem bilemedim
import Foundation
struct Constant {
    static let apiKey: String = "b04b62608f7a4d8e9202add331171180"
    static let baseURL: String = "https://api.rawg.io/api/games"
    static let movieURL: String = baseURL + "?key=" + apiKey
    static func detailURL(for id: Int) -> String {
           return "\(baseURL)/\(id)?key=\(apiKey)"
       }
    
}


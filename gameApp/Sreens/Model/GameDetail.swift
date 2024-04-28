//
//  GameDetail.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 27.04.2024.
//

import Foundation

struct GameDetail : Decodable {
    let id : Int
    let name : String
    let backgroundImage : String
    let metacritic : Int
    let released : String
    let description: String
    
    enum CodingKeys: String, CodingKey{
        case id,metacritic,released,description
        case name = "name_original"
        case backgroundImage = "background_image"
    }
}

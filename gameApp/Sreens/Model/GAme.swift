//
//  GAme.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 25.04.2024.
//

import Foundation

struct firstList: Decodable {
    let results : [Game]
}

struct StoreObject : Decodable {
    let store : Store
}

struct Store : Decodable {
    let name : String
    let storeImage : String
    
    enum CodingKeys: String, CodingKey{
        case name
        case storeImage = "image_background"
    }
}

struct Game : Decodable {
    let id : Int
    let name : String
    let backgroundImage : String
    let rating : Double
    let released : String
    let stores : [StoreObject]
    
    enum CodingKeys: String, CodingKey{
        case id,name,released,rating,stores
        case backgroundImage = "background_image"
    }
}

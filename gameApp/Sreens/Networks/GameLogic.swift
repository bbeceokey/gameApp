//
//  GameLogic.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 25.04.2024.
//

import Foundation

final class GameLogic : GameLogicProtocol {
  
    static let shared : GameLogic = {
        let instance = GameLogic()
        return instance
    }()
    
    func getGAmes(completionHandler: @escaping (Result<firstList,Error>) -> Void) {
        WebService.shared.request(request: Router.gaming, decodeToType: firstList.self, completionHandler: completionHandler)
    }
    
    func getGameDetails(for gameId: Int,completionHandler: @escaping (Result<GameDetail, Error>) -> Void){
        WebService.shared.request(request: Router.details(id: gameId), decodeToType: GameDetail.self, completionHandler: completionHandler)
    }
}

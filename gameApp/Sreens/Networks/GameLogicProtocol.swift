//
//  GameLogicProtocol.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 25.04.2024.
//

import Foundation
protocol GameLogicProtocol{
    func getGAmes(completionHandler: @escaping (Result<firstList, Error>) -> Void)
    func getGameDetails(for gameId: Int,completionHandler: @escaping (Result<GameDetail, Error>) -> Void)
    //func getNowPlayingMovies(completionHandler: @escaping (Result<NowPlayingMovie, Error>) -> Void)
}

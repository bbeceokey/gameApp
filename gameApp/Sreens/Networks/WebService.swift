//
//  WebService.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 25.04.2024.
//

import Alamofire
import Foundation

final class WebService {
    
    static let shared: WebService = {
        let instance = WebService()
        return instance
    }()
    
    func request<T: Decodable>(request: URLRequestConvertible, decodeToType type: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(request).responseData { [weak self] response in
            guard self != nil else { return }
            
            switch response.result {
                
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(decodedData))
                } catch {
                    print("Json decode error")
                }
            case .failure(let error):
                completionHandler(.failure(error.localizedDescription as! Error))
            }
        }
    }
}

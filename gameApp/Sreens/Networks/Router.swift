//
//  Router.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 25.04.2024.
//

import Foundation
import Alamofire

enum Router : URLRequestConvertible {

    case gaming
    case details(id: Int)
    
    
    var method: HTTPMethod {
        switch self {
        case .gaming , .details :
            return .get
        }
        
    }
    var parameters : [String : Any]? {
        switch self {
        case .details, .gaming :
            return nil
        }
    }
    
    var encoding : ParameterEncoding {
        JSONEncoding.default
    }
    
    var url: URL {
        switch self {
        case .gaming:
            let url = URL(string: Constant.movieURL)
            return url!
        case .details(let id):
            let url = URL(string: Constant.detailURL(for: id))
            return url!
        }
    }

    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
}

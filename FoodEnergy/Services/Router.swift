//
//  Router.swift
//  PlaceService
//
//  Created by Dung Vu on 7/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation

enum Foods {
    case GET(foodID: String)
    
    // Get Parameter
    
    var parameters: [String: AnyObject] {
        switch self {
        case .GET(let foodID):
            return ["method" : "food.get", "food_id": foodID]
        }
    }
    
    var method: Method {
        switch self {
        case .GET:
            return .GET
        }
    }
}


enum Router {
    case TrackFood(food: Foods)
    
    var request: URLRequest? {
        let baseURL = API.baseURL
        
        var params = [String: AnyObject]()
        params["oauth_consumer_key"] = API.accessKey
        params["oauth_signature_method"] = "HMAC-SHA1"
        params["oauth_timestamp"] = "\(Int(NSDate().timeIntervalSince1970))"
        params["oauth_nonce"] = "abc"
        params["oauth_version"] = "1.0"
        params["format"] = "json"
        var signature = ""
        var method = Method.GET
        
        switch self {
        case .TrackFood(let food):
            params += food.parameters
            method = food.method
            signature = Parameter.makeSignature(fromParams: params, path: baseURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) ?? "", method: food.method)
            
        }
        
        
        params["oauth_signature"] = signature
        var urlComponent = URLComponents(string: baseURL)
        urlComponent?.queryItems = params.convertToURLQuery()
        guard let url = urlComponent?.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}

extension Dictionary {
    func convertToURLQuery() -> [URLQueryItem] {
        var result = [URLQueryItem]()
        autoreleasepool { () -> () in
            for (key,element) in self {
                if let key = key as? String {
                    let item = URLQueryItem(name: key, value: element as? String)
                    result.append(item)
                }
            }
        }
        
        return result
    }
}


func +=<K: Hashable,V>(left: inout [K: V], right: [K: V]) {
    for (key,value) in right {
        left[key] = value
    }
}

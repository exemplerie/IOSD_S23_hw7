//
//  APITarget.swift
//  Lab_4
//
//  Created by Валерия Харина on 01.07.2023.
//

import Moya
import Foundation

enum APITarget {
    case getCharacters
    case getCharacter(ID: Int)
}

extension APITarget: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://rickandmortyapi.com") else {
            fatalError("Can't get the URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getCharacters:
            return "/api/character"
        case .getCharacter(let ID):
            return "/api/character/" + String(ID)
        }
    }
    
    var method: Moya.Method {
        .get
    }
        
    
    var task: Moya.Task {
           switch self {
           case .getCharacters, .getCharacter:
               return .requestParameters(parameters: [:], encoding: URLEncoding.default)
           }
       }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
            return Data()
        }
}



//
//  NetworkManager.swift
//  Lab_4
//
//  Created by Валерия Харина on 02.07.2023.
//

import Moya
import Foundation

protocol NetworkManagerProtocol {
    var provider: MoyaProvider<APITarget> { get }
    func fetchCharacters(completion: @escaping (Result<[CharacterResponseModel], Error>) -> Void)
    func fetchCharacter(ID: Int, completion: @escaping (Result<CharacterResponseModel, Error>) -> Void)

    
}

class NetworkManager: NetworkManagerProtocol {
    var provider = MoyaProvider<APITarget>()
    
    func fetchCharacters(completion: @escaping (Result<[CharacterResponseModel], Error>) -> Void) {
        request(target: .getCharacters, completion: completion)
    }
    
    func fetchCharacter(ID: Int, completion: @escaping (Result<CharacterResponseModel, Error>) -> Void) {
        request(target: .getCharacter(ID: ID), completion: completion)
    }
}

private extension NetworkManager {
    func request<T:Decodable>(target: APITarget, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

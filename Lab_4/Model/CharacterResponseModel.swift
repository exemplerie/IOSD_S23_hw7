//
//  CharacterResponseModel.swift
//  Lab_4
//
//  Created by Валерия Харина on 02.07.2023.
//

struct CharacterResponseModel: Codable {
    let results: [Character]
    struct Location: Codable {
        var name: String
    }
    struct Character: Codable {
        let id: Int
        let name: String
        let status: String
        var species: String
        let gender: String
        var location: Location
        let image: String
    }
    enum CodingKeys: String, CodingKey {
        case results
    }
}

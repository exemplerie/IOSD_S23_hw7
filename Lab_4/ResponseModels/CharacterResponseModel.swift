//
//  CharacterResponseModel.swift
//  Lab_4
//
//  Created by Валерия Харина on 02.07.2023.
//

import Foundation

struct Location: Codable {
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct CharacterResponseModel: Codable {
    let id: Int
    var name, status, species, gender: String
    let image: String
    var location: Location
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, species, image, location, gender
    }
}

//
//  Character+CoreDataProperties.swift
//  Lab_4
//
//  Created by Валерия Харина on 08.07.2023.
//
//

import Foundation
import CoreData


extension Character {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Character> {
        return NSFetchRequest<Character>(entityName: "Character")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var location: String?
    @NSManaged public var species: String?
    @NSManaged public var status: String?
    @NSManaged public var image: String?

}

extension Character : Identifiable {

}

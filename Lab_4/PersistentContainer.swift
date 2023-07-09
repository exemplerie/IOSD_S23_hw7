//
//  PersistentContainer.swift
//  Lab_4
//
//  Created by Валерия Харина on 08.07.2023.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer {
    
    static let shared: PersistentContainer = {
        let container = PersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error {
                print(error)
            }
        }
        return container
    }()
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

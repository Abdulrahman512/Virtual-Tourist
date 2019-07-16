//
//  File.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Althobaiti on 13/11/1440 AH.
//  Copyright © 1440 Abdulrahman Althobaiti. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let shared = DataController()
    
    let persistentContainer = NSPersistentContainer(name: "VirtualTouristDataModel")
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
}

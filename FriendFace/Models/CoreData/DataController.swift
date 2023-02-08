//
//  DataController.swift
//  Challenge60
//
//  Created by Floriano Fraccastoro on 07/02/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FriendFace")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading data \(error.localizedDescription)")
            }
        }
    }
}

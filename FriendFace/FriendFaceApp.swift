//
//  Challenge60App.swift
//  Challenge60
//
//  Created by Floriano Fraccastoro on 06/02/23.
//

import SwiftUI

@main
struct FriendFaceApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

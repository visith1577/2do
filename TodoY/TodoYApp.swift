//
//  TodoYApp.swift
//  TodoY
//
//  Created by visith kumarapperuma on 2025-10-31.
//

import SwiftUI
internal import CoreData

@main
struct TodoYApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }.foregroundColor(Color.blue)
        }
    }
}

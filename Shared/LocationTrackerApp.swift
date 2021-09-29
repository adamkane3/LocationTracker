//
//  LocationTrackerApp.swift
//  Shared
//
//  Created by Adam Kane on 29/09/2021.
//

import SwiftUI

@main
struct LocationTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

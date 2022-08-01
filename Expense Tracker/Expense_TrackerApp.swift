//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Tsenguun on 1/8/22.
//

import SwiftUI

@main
struct Expense_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

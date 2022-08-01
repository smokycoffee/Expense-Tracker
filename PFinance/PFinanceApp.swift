//
//  PFinanceApp.swift
//  PFinance
//
//  Created by Tsenguun on 2/8/22.
//

import SwiftUI

@main
struct PFinanceApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            DashboardView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

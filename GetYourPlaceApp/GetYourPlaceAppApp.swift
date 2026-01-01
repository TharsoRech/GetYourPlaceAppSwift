//
//  GetYourPlaceAppApp.swift
//  GetYourPlaceApp
//
//  Created by Tharso francisco Rech curia on 01/01/26.
//

import SwiftUI

@main
struct GetYourPlaceAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

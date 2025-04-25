//
//  RankBankApp.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import SwiftUI
import SwiftData

@main
struct RankBankApp: App {
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }

    init() {
        do {
            container = try ModelContainer(for: Folder.self)
        } catch {
            fatalError("\(error)")
        }
    }
}

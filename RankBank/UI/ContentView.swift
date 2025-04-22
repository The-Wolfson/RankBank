//
//  ContentView.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationSplitView {
            FoldersView()
        } detail: {
            ContentUnavailableView(
                "Select a list to view its contents",
                systemImage: "filemenu.and.selection"
            )
        }
    }
}

#Preview {
    ContentView()
}

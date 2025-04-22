//
//  ContentView.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var viewModel: ViewModel
    var body: some View {
        NavigationStack {
            FoldersView(modelContext: viewModel.modelContext)
        }
    }
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var modelContext: ModelContext

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
    }
}

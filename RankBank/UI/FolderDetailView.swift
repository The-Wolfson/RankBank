//
//  FolderDetailView.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import SwiftData
import SwiftUI

struct FolderDetailView: View {
    @State private var viewModel: ViewModel
    var body: some View {
        List {
            ItemsView(modelContext: viewModel.modelContext, parentFolder: viewModel.parentFolder)
        }
        .navigationTitle(viewModel.parentFolder.notes.isEmpty ? viewModel.parentFolder.title : "")
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            if !viewModel.parentFolder.notes.isEmpty {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(viewModel.parentFolder.title)
                            .font(.headline)
                        Text(viewModel.parentFolder.notes)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    init(modelContext: ModelContext, parentFolder: Folder) {
        let viewModel = ViewModel(modelContext: modelContext, parentFolder: parentFolder)
        _viewModel = State(initialValue: viewModel)
    }
}

extension FolderDetailView {
    @Observable
    class ViewModel {
        private(set) var modelContext: ModelContext
       private(set) var parentFolder: Folder

        init(modelContext: ModelContext, parentFolder: Folder) {
            self.modelContext = modelContext
            self.parentFolder = parentFolder
        }
        
        func moveItem(from source: IndexSet, to destination: Int) {
            // move the data here
        }
    }
}

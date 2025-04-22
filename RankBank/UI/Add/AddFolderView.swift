//
//  AddFolderView.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import SwiftUI
import SwiftData

struct AddFolderView: View {
    @State private var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $viewModel.folder.title)
                TextField("Notes", text: $viewModel.folder.notes)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save()
                        dismiss()
                    }
                    .disabled(viewModel.folder.title.isEmpty)
                }
            }
            .navigationTitle(viewModel.navTitle)
        }
    }
    init(modelContext: ModelContext, parentFolder: Folder? = nil, editingFolder: Folder? = nil) {
        let viewModel = ViewModel(modelContext: modelContext, parentFolder: parentFolder)
        _viewModel = State(initialValue: viewModel)
        if let editingFolder {
            viewModel.folder = editingFolder
        }
    }
}

extension AddFolderView {
    @Observable
    class ViewModel {
        private(set) var parentFolder: Folder?
        var folder: Folder = Folder(title: "", notes: "")

        var modelContext: ModelContext

        init(modelContext: ModelContext, parentFolder: Folder?) {
            self.modelContext = modelContext
            self.parentFolder = parentFolder
        }
        func save() {
            folder.parentFolder = parentFolder
            modelContext.insert(folder)
            saveModelContext()
        }
        
        var navTitle: String {
            folder.title.isEmpty ? "Add List" : folder.title
        }
        
        func saveModelContext() {
            do {
                try modelContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

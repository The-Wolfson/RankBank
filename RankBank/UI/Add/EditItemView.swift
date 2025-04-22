//
//  EditItemView.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import SwiftUI
import SwiftData

struct EditItemView: View {
    @State private var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $viewModel.item.title)
                TextField("Notes", text: $viewModel.item.notes)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save()
                        dismiss()
                    }
                    .disabled(viewModel.item.title.isEmpty)
                }
            }
            .navigationTitle(viewModel.item.title.isEmpty ? "New Item" : viewModel.item.title)
        }
    }
    init(modelContext: ModelContext, parentFolder: Folder, editingItem: Item? = nil) {
        let viewModel = ViewModel(modelContext: modelContext, parentFolder: parentFolder)
        _viewModel = State(initialValue: viewModel)
        if let editingItem {
            viewModel.item = editingItem
        }
    }
}

extension EditItemView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var item: Item = Item(title: "", notes: "", rating: 0)
        var parentFolder: Folder
        
        init(modelContext: ModelContext, parentFolder: Folder) {
            self.modelContext = modelContext
            self.parentFolder = parentFolder
        }
        
        func save() {
            item.folder = parentFolder
            modelContext.insert(item)
            
            do {
                try modelContext.save()
            } catch {
                print(error)
            }
        }
    }
}

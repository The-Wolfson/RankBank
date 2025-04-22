//
//  ItemsView.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import SwiftData
import SwiftUI

struct ItemsView: View {
    @State private var viewModel: ViewModel

    var body: some View {
        ForEach(viewModel.items) { item in
            ItemRowView(item: item)
                .contextMenu {
                    Button("Edit", systemImage: "pencil") {
                        viewModel.editingItem = item
                    }
                    Divider()
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        viewModel.deleteItem(item)
                    }
                }
        }
        .onMove(perform: viewModel.moveItem)
        ForEach(viewModel.folders) { folder in
            DisclosureGroup {
                ItemsView(
                    modelContext: viewModel.modelContext,
                    parentFolder: folder
                )
            } label: {
                FolderRowView(folder: folder)
                    .contextMenu {
                        Button("Edit", systemImage: "pencil") {
                            viewModel.editingFolder = folder
                        }
                        Divider()
                        Button(
                            "Delete",
                            systemImage: "trash",
                            role: .destructive
                        ) {
                            viewModel.deleteFolder(folder)
                        }
                    }
            }
        }
        Menu("Add") {
            Button("Add List") {
                viewModel.isShowingAddFolder.toggle()
            }
            Button("Add Item") {
                viewModel.isShowingAddItem.toggle()
            }
        }
        .sheet(isPresented: $viewModel.isShowingAddItem) {
            DispatchQueue.main.async {
                viewModel.fetchData()
            }
        } content: {
            EditItemView(
                modelContext: viewModel.modelContext,
                parentFolder: viewModel.parentFolder
            )
            .presentationDetents([.medium])
        }
        .sheet(item: $viewModel.editingItem) {
            DispatchQueue.main.async {
                viewModel.fetchData()
            }
        } content: { item in
            EditItemView(
                modelContext: viewModel.modelContext,
                parentFolder: item.folder!,
                editingItem: item
            )
            .presentationDetents([.medium])
            .interactiveDismissDisabled()
        }

        .sheet(isPresented: $viewModel.isShowingAddFolder) {
            DispatchQueue.main.async {
                viewModel.fetchData()
            }
        } content: {
            AddFolderView(
                modelContext: viewModel.modelContext,
                parentFolder: viewModel.parentFolder
            )
            .presentationDetents([.medium])
        }
        .sheet(item: $viewModel.editingFolder) {
            DispatchQueue.main.async {
                viewModel.fetchData()
            }
        } content: { folder in
            AddFolderView(
                modelContext: viewModel.modelContext,
                editingFolder: folder
            )
            .presentationDetents([.medium])
            .interactiveDismissDisabled()
        }
    }
    init(modelContext: ModelContext, parentFolder: Folder) {
        let viewModel = ViewModel(
            modelContext: modelContext,
            parentFolder: parentFolder
        )
        _viewModel = State(initialValue: viewModel)
    }
}

extension ItemsView {
    @Observable
    class ViewModel {
        private(set) var modelContext: ModelContext
        private(set) var parentFolder: Folder
        var isShowingAddFolder: Bool = false
        var isShowingAddItem: Bool = false
        var editingFolder: Folder?
        var editingItem: Item?
        var items = [Item]()
        var folders = [Folder]()

        init(modelContext: ModelContext, parentFolder: Folder) {
            self.modelContext = modelContext
            self.parentFolder = parentFolder

            fetchData()
        }

        func moveItem(from source: IndexSet, to destination: Int) {
            items.move(
                fromOffsets: source,
                toOffset: destination
            )

            for (index, item) in items.enumerated() {
                item.rating = index + 1
            }

            do {
                try modelContext.save()
            } catch {
                print(error)
            }
        }

        func deleteFolder(_ folder: Folder) {
            modelContext.delete(folder)

            do {
                try modelContext.save()
            } catch {
                print(error)
            }

            fetchData()
        }

        func deleteItem(_ item: Item) {
            modelContext.delete(item)

            do {
                try modelContext.save()
            } catch {
                print(error)
            }

            fetchData()
        }

        func fetchData() {
            withAnimation {
                let parentFolderId = parentFolder.id
                let folderDescriptor = FetchDescriptor<Folder>(
                    predicate: #Predicate<Folder> { folder in
                        folder.parentFolder?.id == parentFolderId
                    },
                    sortBy: [SortDescriptor(\.title)]
                )

                let itemDescriptor = FetchDescriptor<Item>(
                    predicate: #Predicate<Item> { item in
                        item.folder?.id == parentFolderId
                    },
                    sortBy: [SortDescriptor(\.rating)]
                )
                do {
                    items = try modelContext.fetch(itemDescriptor)
                    folders = try modelContext.fetch(folderDescriptor)
                } catch {
                    print(error)
                }

                for (index, item) in items.enumerated() {
                    item.rating = index + 1
                }
            }
        }
    }
}

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
        .onMove {
            viewModel.moveFolder(from: $0, to: $1)
        }
        Button("Add Item") {
            viewModel.isShowingAddFolder.toggle()
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
        var editingFolder: Folder?
        var folders = [Folder]()

        init(modelContext: ModelContext, parentFolder: Folder) {
            self.modelContext = modelContext
            self.parentFolder = parentFolder

            fetchData()
        }

        func moveFolder(from source: IndexSet, to destination: Int) {
            folders.move(
                fromOffsets: source,
                toOffset: destination
            )

            for (index, folder) in folders.enumerated() {
                folder.rating = index + 1
            }

            do {
                try modelContext.save()
            } catch {
                print(error)
            }

            fetchData()
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

        func fetchData() {
            withAnimation {
                let parentFolderId = parentFolder.id
                let folderDescriptor = FetchDescriptor<Folder>(
                    predicate: #Predicate<Folder> { folder in
                        folder.parentFolder?.id == parentFolderId
                    },
                    sortBy: [SortDescriptor(\.rating)]
                )
                do {
                    folders = try modelContext.fetch(folderDescriptor)
                } catch {
                    print(error)
                }

                for (index, folder) in folders.enumerated() {
                    folder.rating = index + 1
                }
            }
        }
    }
}

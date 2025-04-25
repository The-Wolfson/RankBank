//
//  FormsView.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import SwiftData
import SwiftUI

struct FoldersView: View {
    @State private var viewModel: ViewModel

    var body: some View {
       Group {
           if viewModel.folders.isEmpty {
               ContentUnavailableView {
                   Label("No Lists", systemImage: "list.bullet.rectangle.portrait")
               } actions: {
                   Button("Add List") {
                       viewModel.isShowingAddSheet.toggle()
                   }
               }

           } else {
               List(viewModel.folders) { folder in
                   NavigationLink(value: folder) {
                       VStack(alignment: .leading) {
                           Text(folder.title)
                               .bold()
                           if !folder.notes.isEmpty {
                               Text(folder.notes)
                                   .font(.caption)
                           }
                       }
                   }
                   .contextMenu {
                       Button("Edit", systemImage: "pencil") {
                           viewModel.editingFolder = folder
                       }
                       Divider()
                       Button("Delete", systemImage: "trash", role: .destructive) {
                           viewModel.delete(folder: folder)
                       }
                   }
               }
               .navigationDestination(for: Folder.self) { folder in
                   FolderDetailView(
                    modelContext: viewModel.modelContext,
                    parentFolder: folder
                   )
               }
           }
        }
        .navigationTitle("Lists")
        .toolbar {
            Button("Add List", systemImage: "plus") {
                viewModel.isShowingAddSheet.toggle()
            }
        }
        .sheet(isPresented: $viewModel.isShowingAddSheet) {
            viewModel.fetchData()
        } content: {
            AddFolderView(modelContext: viewModel.modelContext)
                .presentationDetents([.medium])
        }
        .sheet(item: $viewModel.editingFolder) {
            viewModel.fetchData()
        } content: { folder in
            AddFolderView(
                modelContext: viewModel.modelContext,
                editingFolder: folder
            )
            .presentationDetents([.medium])
            .interactiveDismissDisabled()
        }
    }
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

extension FoldersView {
    @Observable
    class ViewModel {
        private(set) var modelContext: ModelContext
        private(set) var folders: [Folder] = []
        var isShowingAddSheet: Bool = false
        var editingFolder: Folder?

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }

        func delete(folder: Folder) {
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
                do {
                    let descriptor = FetchDescriptor<Folder>(
                        predicate: #Predicate<Folder> { folder in
                            folder.parentFolder == nil
                        },
                        sortBy: [SortDescriptor(\.title)]
                    )
                    folders = try modelContext.fetch(descriptor)
                } catch {
                    print(error)
                }
            }
        }
    }
}

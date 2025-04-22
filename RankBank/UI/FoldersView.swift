//
//  FoldersView.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import SwiftData
import SwiftUI

struct FoldersView: View {
    @Environment(\.modelContext) var modelContext
    @Query var folders: [Folder]
    @State private var isShowingAddFolder: Bool = false
    @State private var newFolder: Folder = Folder(title: "")
    var body: some View {
        Group {
            if folders.isEmpty {
                ContentUnavailableView(
                    "No Lists",
                    systemImage: "folder",
                    description: Text("Add a List to get started")
                )
            } else {
                List(folders) { folder in
                    NavigationLink(value: folder) {
                        Text(folder.title)
                    }
                    .swipeActions {
                        Button(
                            "Delete",
                            systemImage: "trash",
                            role: .destructive
                        ) {
                            deleteFolder(folder: folder)
                        }
                        Button("Edit", systemImage: "pencil") {
                            newFolder = folder
                            isShowingAddFolder.toggle()
                        }
                    }
                    .contextMenu {
                        Button("Edit", systemImage: "pencil") {
                            newFolder = folder
                            isShowingAddFolder.toggle()
                        }
                        Divider()
                        Button(
                            "Delete",
                            systemImage: "trash",
                            role: .destructive
                        ) {
                            deleteFolder(folder: folder)
                        }
                    }
                }
                .navigationDestination(for: Folder.self) { folder in
                    ItemsView(folder: folder)
                }
            }
        }
        .navigationTitle("Lists")
        .toolbar {
            Button("Add List", systemImage: "plus") {
                isShowingAddFolder.toggle()
            }
        }
        .alert("New List", isPresented: $isShowingAddFolder) {
            TextField("Title", text: $newFolder.title)
            Button("Cancel", role: .cancel) {
                newFolder = Folder(title: "")
            }
            Button("Save") {
                addFolder()
            }
            .disabled(newFolder.title.isEmpty)
        }
    }

    func deleteFolder(folder: Folder) {
        withAnimation {
            modelContext.delete(folder)
            saveModelContext()
        }
    }

    func addFolder() {
        modelContext.insert(newFolder)
        saveModelContext()
        newFolder = Folder(title: "")
    }

    func saveModelContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
}

#Preview {
    FoldersView()
}

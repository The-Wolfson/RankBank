//
//  ItemsView.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import SwiftData
import SwiftUI

struct ItemsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Item.rating) var items: [Item]
    let folder: Folder
    @State private var isShowingEditItem: Bool = false
    @State private var editingItem: Item = Item(
        name: "",
        notes: "",
        rating: 0,
        folder: nil
    )
    init(folder: Folder) {
        self.folder = folder
        let id = folder.persistentModelID
        let predicate = #Predicate<Item> { item in
            item.folder?.persistentModelID == id
        }
        _items = Query(filter: predicate, sort: \.rating)
    }
    var body: some View {
        Group {
            if !items.isEmpty {
                List {
                    ForEach(items) { item in
                        ItemRowView(item: item)
                            .swipeActions {
                                Button(
                                    "Delete",
                                    systemImage: "trash",
                                    role: .destructive
                                ) {
                                    deleteItem(item: item)
                                }
                                Button("Edit", systemImage: "pencil") {
                                    editingItem = item
                                    isShowingEditItem.toggle()
                                }
                            }
                            .contextMenu {
                                Button("Edit", systemImage: "pencil") {
                                    editingItem = item
                                    isShowingEditItem.toggle()
                                }
                                Divider()
                                Button(
                                    "Delete",
                                    systemImage: "trash",
                                    role: .destructive
                                ) {
                                    deleteItem(item: item)
                                }
                            }
                    }
                    .onMove { source, destination in
                        var tempItems = items
                        tempItems.move(
                            fromOffsets: source,
                            toOffset: destination
                        )

                        for (index, tempItem) in tempItems.enumerated() {
                            if let item = items.first(where: {
                                $0.id == tempItem.id
                            }) {
                                item.rating = index + 1
                            }
                        }
                    }
                }
            } else {
                ContentUnavailableView(
                    "No Items in this list",
                    systemImage: "clipboard"
                )
            }
        }
        .navigationTitle(folder.title)
        .toolbar {
            Button("Add Item", systemImage: "plus") {
                editingItem = Item(
                    name: "",
                    notes: "",
                    rating: 0,
                    folder: folder
                )
                isShowingEditItem.toggle()
            }
        }
        .alert("Edit Item", isPresented: $isShowingEditItem) {
            TextField("Name", text: $editingItem.name)
            TextField("Description", text: $editingItem.notes)
            Button("Save") {
                withAnimation {
                    modelContext.insert(editingItem)
                    saveModelContext()
                    for (index, item) in items.enumerated() {
                        item.rating = index + 1
                    }
                }
            }
            .disabled(editingItem.name.isEmpty)
        }
    }
    func saveModelContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
    func deleteItem(item: Item) {
        withAnimation {
            modelContext.delete(item)
            saveModelContext()
            for (index, item) in items.enumerated() {
                item.rating = index + 1
            }
        }
    }
}

#Preview {
    ItemsView(folder: Folder(title: "Name"))
}

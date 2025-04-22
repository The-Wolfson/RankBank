//
//  Folder.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import Foundation
import SwiftData

@Model
class Folder {
    var title: String
    var notes: String
    var parentFolder: Folder?
    
    @Relationship(deleteRule: .cascade, inverse: \Folder.parentFolder)
    var folders: [Folder] = []
    
    @Relationship(deleteRule: .cascade, inverse: \Item.folder)
    var items: [Item] = []
    
    init(title: String, notes: String, parentFolder: Folder? = nil) {
        self.title = title
        self.notes = notes
        self.parentFolder = parentFolder
    }
}

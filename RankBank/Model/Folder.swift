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
    var rating: Int
    var parentFolder: Folder?
    
    @Relationship(deleteRule: .cascade, inverse: \Folder.parentFolder)
    var folders: [Folder] = []
    
    init(title: String, notes: String, rating: Int = 0, parentFolder: Folder? = nil) {
        self.title = title
        self.notes = notes
        self.rating = rating
        self.parentFolder = parentFolder
    }
}

//
//  Item.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import Foundation
import SwiftData

@Model
class Item {
    var name: String
    var notes: String
    var rating: Int

    var folder: Folder?

    init(name: String, notes: String, rating: Int, folder: Folder?) {
        self.name = name
        self.notes = notes
        self.rating = rating
        self.folder = folder
    }
}

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
    var title: String
    var notes: String
    var rating: Int

    var folder: Folder?

    init(title: String, notes: String, rating: Int) {
        self.title = title
        self.notes = notes
        self.rating = rating
    }
}

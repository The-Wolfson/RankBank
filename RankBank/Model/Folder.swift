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

    @Relationship(deleteRule: .cascade, inverse: \Item.folder)
    var items: [Item] = []

    init(title: String) {
        self.title = title
    }
}

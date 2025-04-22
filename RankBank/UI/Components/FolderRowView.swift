//
//  FolderRowView.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import SwiftUI

struct FolderRowView: View {
    let folder: Folder
    var body: some View {
        VStack(alignment: .leading) {
            Text(folder.title)
                .bold()
            if !folder.notes.isEmpty {
                Text(folder.notes)
                    .font(.caption)
            }
        }
    }
}

//
//  ItemRowView.swift
//  RankBank
//
//  Created by Joshua Wolfson on 22/4/2025.
//

import SwiftUI

struct ItemRowView: View {
    let item: Item
    var body: some View {
        HStack {
            Text(item.rating, format: .number)
                .font(.title)
            VStack(alignment: .leading) {
                Text(item.title)
                if !item.notes.isEmpty {
                    Text(item.notes)
                        .font(.caption)
                }
            }
        }
    }
}

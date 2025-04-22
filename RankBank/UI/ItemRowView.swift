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
                .font(.title2)
            VStack(alignment: .leading) {
                Text(item.name)
                Text(item.notes)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    ItemRowView(
        item: Item(name: "Rick", notes: "Good fellow", rating: 1, folder: nil)
    )
}

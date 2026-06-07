//
//  SearchHistoryView.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import SwiftUI

struct SearchHistoryView: View {
    let searches: [String]
    let onSelect: (String) -> Void
    let onClear: () -> Void

    var body: some View {
        if searches.isEmpty == false {
            VStack(alignment: .leading, spacing: Spacing.small) {
                HStack {
                    Text("Recent searches")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button("Clear", action: onClear)
                        .font(.footnote)
                        .accessibilityIdentifier("clearSearchHistoryButton")
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.small) {
                        ForEach(searches, id: \.self) { search in
                            Button {
                                onSelect(search)
                            } label: {
                                Label(search, systemImage: "clock.arrow.circlepath")
                            }
                            .buttonStyle(.bordered)
                            .accessibilityIdentifier("recentSearch_\(search)")
                        }
                    }
                }
            }
        }
    }
}

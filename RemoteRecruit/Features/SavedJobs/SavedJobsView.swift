//
//  SavedJobsView.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import SwiftUI

struct SavedJobsView: View {
    @StateObject private var viewModel: SavedJobsViewModel

    init(viewModel: SavedJobsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.medium) {
                if viewModel.jobs.isEmpty {
                    EmptyStateView(
                        title: "No saved jobs yet",
                        message: "Bookmark jobs from the list and they will appear here."
                    )
                    .padding(.horizontal, Spacing.medium)
                } else {
                    ForEach(viewModel.jobs) { job in
                        JobCardView(job: job, isSaved: true)
                            .padding(.horizontal, Spacing.medium)
                            .contextMenu {
                                Button(role: .destructive) {
                                    Task { await viewModel.remove(job) }
                                } label: {
                                    Label("Remove", systemImage: "bookmark.slash")
                                }
                            }
                    }
                }
            }
            .padding(.vertical, Spacing.medium)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Saved Jobs")
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
        .accessibilityIdentifier("savedJobsScreen")
    }
}

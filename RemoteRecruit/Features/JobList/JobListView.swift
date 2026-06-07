//
//  JobListView.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import SwiftUI

struct JobListView: View {
    @StateObject private var viewModel: JobListViewModel

    init(viewModel: JobListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.medium) {
                SearchHistoryView(
                    searches: viewModel.recentSearches,
                    onSelect: viewModel.selectRecentSearch,
                    onClear: viewModel.clearSearchHistory
                )
                .padding(.horizontal, Spacing.medium)

                content
                    .padding(.horizontal, Spacing.medium)
            }
            .padding(.vertical, Spacing.medium)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Remote Jobs")
        .searchable(text: $viewModel.searchText, prompt: "Search title or company")
        .onSubmit(of: .search, viewModel.persistCurrentSearch)
        .refreshable { await viewModel.refresh() }
        .task { await viewModel.loadJobs() }
        .accessibilityIdentifier("jobListScreen")
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            LoadingJobsView()
        case .loaded:
            ForEach(viewModel.visibleJobs) { job in
                JobRow(viewModel: viewModel, job: job)
            }
        case .empty:
            EmptyStateView(
                title: "No jobs found",
                message: "Try a different job title or company name."
            )
        case .error(let message):
            EmptyStateView(
                title: "Something went wrong",
                message: message,
                retryTitle: "Retry"
            ) {
                Task { await viewModel.refresh() }
            }
        }
    }
}

private struct JobRow: View {
    @ObservedObject var viewModel: JobListViewModel
    let job: Job
    @State private var isSaved = false

    var body: some View {
        NavigationLink {
            JobDetailView(
                viewModel: JobDetailViewModel(
                    job: job,
                    saveJobUseCase: viewModelSaveUseCaseProxy
                )
            )
        } label: {
            JobCardView(job: job, isSaved: isSaved)
        }
        .buttonStyle(.plain)
        .scaleEffect(1)
        .contextMenu {
            Button {
                Task { isSaved = await viewModel.toggleSaved(job) }
            } label: {
                Label(isSaved ? "Remove saved job" : "Save job", systemImage: isSaved ? "bookmark.slash" : "bookmark")
            }
        }
        .task {
            isSaved = await viewModel.isSaved(job)
        }
    }

    private var viewModelSaveUseCaseProxy: SaveJobUseCaseProtocol {
        JobListSaveProxy(viewModel: viewModel)
    }
}

private struct JobListSaveProxy: SaveJobUseCaseProtocol {
    let viewModel: JobListViewModel

    func isSaved(_ job: Job) async -> Bool {
        await viewModel.isSaved(job)
    }

    func toggle(_ job: Job) async throws -> Bool {
        await viewModel.toggleSaved(job)
    }
}

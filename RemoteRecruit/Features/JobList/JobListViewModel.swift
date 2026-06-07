//
//  JobListViewModel.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation
import Combine

@MainActor
final class JobListViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    @Published private(set) var jobs: [Job] = []
    @Published private(set) var visibleJobs: [Job] = []
    @Published private(set) var state: ViewState = .idle
    @Published private(set) var recentSearches: [String] = []
    @Published var searchText = "" {
        didSet { debounceSearch() }
    }

    private let fetchJobsUseCase: FetchJobsUseCaseProtocol
    private let saveJobUseCase: SaveJobUseCaseProtocol
    private let searchHistoryStore: SearchHistoryStoreProtocol
    private var searchTask: Task<Void, Never>?

    init(
        fetchJobsUseCase: FetchJobsUseCaseProtocol,
        saveJobUseCase: SaveJobUseCaseProtocol,
        searchHistoryStore: SearchHistoryStoreProtocol
    ) {
        self.fetchJobsUseCase = fetchJobsUseCase
        self.saveJobUseCase = saveJobUseCase
        self.searchHistoryStore = searchHistoryStore
        self.recentSearches = searchHistoryStore.recentSearches()
    }

    func loadJobs() async {
        guard state != .loading else { return }
        state = .loading
        do {
            jobs = try await fetchJobsUseCase.execute()
            applySearch()
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func refresh() async {
        state = .idle
        await loadJobs()
    }

    func selectRecentSearch(_ query: String) {
        searchText = query
    }

    func clearSearchHistory() {
        searchHistoryStore.clear()
        recentSearches = []
    }

    func persistCurrentSearch() {
        searchHistoryStore.save(searchText)
        recentSearches = searchHistoryStore.recentSearches()
    }

    func isSaved(_ job: Job) async -> Bool {
        await saveJobUseCase.isSaved(job)
    }

    func toggleSaved(_ job: Job) async -> Bool {
        (try? await saveJobUseCase.toggle(job)) ?? false
    }

    private func debounceSearch() {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(280))
            guard !Task.isCancelled else { return }
            self?.applySearch()
        }
    }

    private func applySearch() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            visibleJobs = jobs
        } else {
            visibleJobs = jobs.filter { $0.searchableText.contains(trimmed.lowercased()) }
            searchHistoryStore.save(trimmed)
            recentSearches = searchHistoryStore.recentSearches()
        }

        state = visibleJobs.isEmpty ? .empty : .loaded
    }
}

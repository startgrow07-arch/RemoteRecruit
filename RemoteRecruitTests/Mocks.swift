//
//  Mocks.swift
//  RemoteRecruitTests
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation
@testable import RemoteRecruit

struct MockFetchJobsUseCase: FetchJobsUseCaseProtocol {
    let result: Result<[Job], Error>

    func execute() async throws -> [Job] {
        try result.get()
    }
}

actor MockSaveJobUseCase: SaveJobUseCaseProtocol {
    private var savedIDs: Set<String> = []

    func isSaved(_ job: Job) async -> Bool {
        savedIDs.contains(job.id)
    }

    func toggle(_ job: Job) async throws -> Bool {
        if savedIDs.contains(job.id) {
            savedIDs.remove(job.id)
            return false
        } else {
            savedIDs.insert(job.id)
            return true
        }
    }
}

struct MockRemoteJobService: RemoteJobServiceProtocol {
    let result: Result<[Job], Error>

    func fetchJobs() async throws -> [Job] {
        try result.get()
    }
}

struct MockLocalJobService: LocalJobServiceProtocol {
    let result: Result<[Job], Error>

    func fetchJobs() async throws -> [Job] {
        try result.get()
    }
}

actor InMemorySavedJobsStore: SavedJobsStoreProtocol {
    private var jobs: [Job] = []

    func load() async -> [Job] {
        jobs
    }

    func save(_ jobs: [Job]) async throws {
        self.jobs = jobs
    }
}

final class InMemorySearchHistoryStore: SearchHistoryStoreProtocol {
    private var values: [String] = []

    func recentSearches() -> [String] {
        values
    }

    func save(_ query: String) {
        values = [query] + values.filter { $0 != query }
    }

    func clear() {
        values = []
    }
}

//
//  JobRepositoryTests.swift
//  RemoteRecruitTests
//
//  Created by Chittranjan on 06/06/26.
//

import XCTest
@testable import RemoteRecruit

@MainActor
final class JobRepositoryTests: XCTestCase {
    func testFetchJobsUsesRemoteWhenAvailable() async throws {
        let repository = JobRepository(
            remoteService: MockRemoteJobService(result: .success([.preview])),
            localService: MockLocalJobService(result: .success([])),
            savedJobsStore: InMemorySavedJobsStore()
        )

        let jobs = try await repository.fetchJobs()

        XCTAssertEqual(jobs, [.preview])
    }

    func testFetchJobsFallsBackToLocalWhenRemoteFails() async throws {
        let localJob = Job.preview
        let repository = JobRepository(
            remoteService: MockRemoteJobService(result: .failure(NetworkError.requestFailed)),
            localService: MockLocalJobService(result: .success([localJob])),
            savedJobsStore: InMemorySavedJobsStore()
        )

        let jobs = try await repository.fetchJobs()

        XCTAssertEqual(jobs, [localJob])
    }

    func testSavedJobsCanBeSavedAndRemoved() async throws {
        let repository = JobRepository(
            remoteService: MockRemoteJobService(result: .success([])),
            localService: MockLocalJobService(result: .success([])),
            savedJobsStore: InMemorySavedJobsStore()
        )

        try await repository.save(.preview)
        let isSaved = await repository.isSaved(.preview)
        XCTAssertTrue(isSaved)

        try await repository.remove(.preview)
        let isRemoved = await repository.isSaved(.preview)
        XCTAssertFalse(isRemoved)
    }
}

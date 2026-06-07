//
//  JobListViewModelTests.swift
//  RemoteRecruitTests
//
//  Created by Chittranjan on 06/06/26.
//

import XCTest
@testable import RemoteRecruit

@MainActor
final class JobListViewModelTests: XCTestCase {
    private let designerApplyURL = URL(string: "https://example.com/designer") ?? URL(fileURLWithPath: "/")

    func testLoadJobsShowsFetchedJobs() async {
        let viewModel = JobListViewModel(
            fetchJobsUseCase: MockFetchJobsUseCase(result: .success([.preview])),
            saveJobUseCase: MockSaveJobUseCase(),
            searchHistoryStore: InMemorySearchHistoryStore()
        )

        await viewModel.loadJobs()

        XCTAssertEqual(viewModel.visibleJobs, [.preview])
        XCTAssertEqual(viewModel.state, .loaded)
    }

    func testLoadJobsShowsErrorWhenFetchFails() async {
        let viewModel = JobListViewModel(
            fetchJobsUseCase: MockFetchJobsUseCase(result: .failure(NetworkError.requestFailed)),
            saveJobUseCase: MockSaveJobUseCase(),
            searchHistoryStore: InMemorySearchHistoryStore()
        )

        await viewModel.loadJobs()

        if case .error(let message) = viewModel.state {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected error state")
        }
    }

    func testSearchFiltersByCompanyAndStoresHistory() async throws {
        let jobs = [
            Job.preview,
            Job(
                id: "designer",
                title: "Product Designer",
                companyName: "Quiet Studio",
                companyDescription: "A small design studio.",
                location: "Remote",
                salaryRange: "$90k - $120k",
                jobType: "Full-time",
                postedDate: Date(),
                description: "Design thoughtful product experiences.",
                applyURL: designerApplyURL
            )
        ]
        let history = InMemorySearchHistoryStore()
        let viewModel = JobListViewModel(
            fetchJobsUseCase: MockFetchJobsUseCase(result: .success(jobs)),
            saveJobUseCase: MockSaveJobUseCase(),
            searchHistoryStore: history
        )

        await viewModel.loadJobs()
        viewModel.searchText = "northstar"
        try await Task.sleep(for: .milliseconds(350))

        XCTAssertEqual(viewModel.visibleJobs, [.preview])
        XCTAssertEqual(history.recentSearches(), ["northstar"])
    }
}

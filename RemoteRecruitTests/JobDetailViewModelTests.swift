//
//  JobDetailViewModelTests.swift
//  RemoteRecruitTests
//
//  Created by Chittranjan on 06/06/26.
//

import XCTest
@testable import RemoteRecruit

@MainActor
final class JobDetailViewModelTests: XCTestCase {
    func testToggleSavedUpdatesState() async {
        let viewModel = JobDetailViewModel(job: .preview, saveJobUseCase: MockSaveJobUseCase())

        await viewModel.load()
        XCTAssertFalse(viewModel.isSaved)

        await viewModel.toggleSaved()
        XCTAssertTrue(viewModel.isSaved)
    }
}

//
//  FetchJobsUseCase.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

protocol FetchJobsUseCaseProtocol {
    func execute() async throws -> [Job]
}

struct FetchJobsUseCase: FetchJobsUseCaseProtocol {
    private let repository: JobRepositoryProtocol

    init(repository: JobRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Job] {
        try await repository.fetchJobs()
    }
}

//
//  SavedJobsUseCase.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

protocol SavedJobsUseCaseProtocol {
    func execute() async -> [Job]
}

struct SavedJobsUseCase: SavedJobsUseCaseProtocol {
    private let repository: JobRepositoryProtocol

    init(repository: JobRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> [Job] {
        await repository.savedJobs()
    }
}

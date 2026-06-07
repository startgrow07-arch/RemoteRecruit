//
//  SaveJobUseCase.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

protocol SaveJobUseCaseProtocol {
    func isSaved(_ job: Job) async -> Bool
    func toggle(_ job: Job) async throws -> Bool
}

struct SaveJobUseCase: SaveJobUseCaseProtocol {
    private let repository: JobRepositoryProtocol

    init(repository: JobRepositoryProtocol) {
        self.repository = repository
    }

    func isSaved(_ job: Job) async -> Bool {
        await repository.isSaved(job)
    }

    @discardableResult
    func toggle(_ job: Job) async throws -> Bool {
        if await repository.isSaved(job) {
            try await repository.remove(job)
            return false
        } else {
            try await repository.save(job)
            return true
        }
    }
}

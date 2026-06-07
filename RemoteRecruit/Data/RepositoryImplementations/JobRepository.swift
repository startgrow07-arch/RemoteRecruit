//
//  JobRepository.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

final class JobRepository: JobRepositoryProtocol {
    private let remoteService: RemoteJobServiceProtocol
    private let localService: LocalJobServiceProtocol
    private let savedJobsStore: SavedJobsStoreProtocol

    init(
        remoteService: RemoteJobServiceProtocol,
        localService: LocalJobServiceProtocol,
        savedJobsStore: SavedJobsStoreProtocol
    ) {
        self.remoteService = remoteService
        self.localService = localService
        self.savedJobsStore = savedJobsStore
    }

    func fetchJobs() async throws -> [Job] {
        do {
            let jobs = try await remoteService.fetchJobs()
            return jobs
        } catch {
            let jobs = try await localService.fetchJobs()
            return jobs
        }
    }

    func savedJobs() async -> [Job] {
        await savedJobsStore.load()
    }

    func isSaved(_ job: Job) async -> Bool {
        await savedJobsStore.load().contains(where: { $0.id == job.id })
    }

    func save(_ job: Job) async throws {
        var jobs = await savedJobsStore.load()
        guard jobs.contains(where: { $0.id == job.id }) == false else { return }
        jobs.insert(job, at: 0)
        try await savedJobsStore.save(jobs)
    }

    func remove(_ job: Job) async throws {
        let jobs = await savedJobsStore.load().filter { $0.id != job.id }
        try await savedJobsStore.save(jobs)
    }
}

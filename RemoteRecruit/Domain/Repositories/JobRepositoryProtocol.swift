//
//  JobRepositoryProtocol.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

protocol JobRepositoryProtocol {
    func fetchJobs() async throws -> [Job]
    func savedJobs() async -> [Job]
    func isSaved(_ job: Job) async -> Bool
    func save(_ job: Job) async throws
    func remove(_ job: Job) async throws
}

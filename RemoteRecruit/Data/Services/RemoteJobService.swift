//
//  RemoteJobService.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

protocol RemoteJobServiceProtocol {
    func fetchJobs() async throws -> [Job]
}

struct RemoteJobService: RemoteJobServiceProtocol {
    private let apiClient: APIClientProtocol
    private let baseURL = URL(string: "https://remotive.com") ?? URL(fileURLWithPath: "/")

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchJobs() async throws -> [Job] {
        let endpoint = Endpoint(path: "/api/remote-jobs")
        let response: RemotiveJobsResponseDTO = try await apiClient.get(endpoint, baseURL: baseURL)
        return response.jobs.map { $0.toDomain() }
    }
}

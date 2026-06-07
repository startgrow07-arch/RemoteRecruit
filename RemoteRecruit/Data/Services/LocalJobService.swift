//
//  LocalJobService.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

protocol LocalJobServiceProtocol {
    func fetchJobs() async throws -> [Job]
}

struct LocalJobService: LocalJobServiceProtocol {
    private let bundle: Bundle
    private let fileName: String

    init(bundle: Bundle = .main, fileName: String = "jobs") {
        self.bundle = bundle
        self.fileName = fileName
    }

    func fetchJobs() async throws -> [Job] {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw NetworkError.noData
        }

        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder.remoteRecruit.decode(JobsResponseDTO.self, from: data)
            return response.jobs.map { $0.toDomain() }
        } catch let error as NetworkError {
            throw error
        } catch is DecodingError {
            throw NetworkError.decodingFailed
        } catch {
            throw NetworkError.noData
        }
    }
}

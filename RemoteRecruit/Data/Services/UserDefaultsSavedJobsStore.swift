//
//  UserDefaultsSavedJobsStore.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

protocol SavedJobsStoreProtocol {
    func load() async -> [Job]
    func save(_ jobs: [Job]) async throws
}

final class UserDefaultsSavedJobsStore: SavedJobsStoreProtocol {
    private let userDefaults: UserDefaults
    private let key: String

    init(userDefaults: UserDefaults = .standard, key: String = "remoteRecruit.savedJobs") {
        self.userDefaults = userDefaults
        self.key = key
    }

    func load() async -> [Job] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder.remoteRecruit.decode([Job].self, from: data)) ?? []
    }

    func save(_ jobs: [Job]) async throws {
        let data = try JSONEncoder.remoteRecruit.encode(jobs)
        userDefaults.set(data, forKey: key)
    }
}

//
//  UserDefaultsSearchHistoryStore.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

protocol SearchHistoryStoreProtocol {
    func recentSearches() -> [String]
    func save(_ query: String)
    func clear()
}

final class UserDefaultsSearchHistoryStore: SearchHistoryStoreProtocol {
    private let userDefaults: UserDefaults
    private let key: String
    private let limit: Int

    init(userDefaults: UserDefaults = .standard, key: String = "remoteRecruit.recentSearches", limit: Int = 8) {
        self.userDefaults = userDefaults
        self.key = key
        self.limit = limit
    }

    func recentSearches() -> [String] {
        userDefaults.stringArray(forKey: key) ?? []
    }

    func save(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else { return }

        var values = recentSearches().filter { $0.caseInsensitiveCompare(trimmed) != .orderedSame }
        values.insert(trimmed, at: 0)
        userDefaults.set(Array(values.prefix(limit)), forKey: key)
    }

    func clear() {
        userDefaults.removeObject(forKey: key)
    }
}

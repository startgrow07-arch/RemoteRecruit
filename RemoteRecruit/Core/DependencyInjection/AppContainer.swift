//
//  AppContainer.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

struct AppContainer {
    let fetchJobsUseCase: FetchJobsUseCaseProtocol
    let saveJobUseCase: SaveJobUseCaseProtocol
    let savedJobsUseCase: SavedJobsUseCaseProtocol
    let searchHistoryStore: SearchHistoryStoreProtocol

    static func makeDefault() -> AppContainer {
        let apiClient = URLSessionAPIClient()
        let remoteService = RemoteJobService(apiClient: apiClient)
        let localService = LocalJobService()
        let savedJobsStore = UserDefaultsSavedJobsStore()
        let repository = JobRepository(
            remoteService: remoteService,
            localService: localService,
            savedJobsStore: savedJobsStore
        )

        return AppContainer(
            fetchJobsUseCase: FetchJobsUseCase(repository: repository),
            saveJobUseCase: SaveJobUseCase(repository: repository),
            savedJobsUseCase: SavedJobsUseCase(repository: repository),
            searchHistoryStore: UserDefaultsSearchHistoryStore()
        )
    }
}

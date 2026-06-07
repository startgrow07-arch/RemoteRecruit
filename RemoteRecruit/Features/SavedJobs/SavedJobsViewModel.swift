//
//  SavedJobsViewModel.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation
import Combine

@MainActor
final class SavedJobsViewModel: ObservableObject {
    @Published private(set) var jobs: [Job] = []

    private let savedJobsUseCase: SavedJobsUseCaseProtocol
    private let saveJobUseCase: SaveJobUseCaseProtocol

    init(savedJobsUseCase: SavedJobsUseCaseProtocol, saveJobUseCase: SaveJobUseCaseProtocol) {
        self.savedJobsUseCase = savedJobsUseCase
        self.saveJobUseCase = saveJobUseCase
    }

    func load() async {
        jobs = await savedJobsUseCase.execute()
    }

    func remove(_ job: Job) async {
        _ = try? await saveJobUseCase.toggle(job)
        await load()
    }
}

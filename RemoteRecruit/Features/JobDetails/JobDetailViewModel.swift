//
//  JobDetailViewModel.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation
import Combine

@MainActor
final class JobDetailViewModel: ObservableObject {
    let job: Job
    @Published private(set) var isSaved = false

    private let saveJobUseCase: SaveJobUseCaseProtocol

    init(job: Job, saveJobUseCase: SaveJobUseCaseProtocol) {
        self.job = job
        self.saveJobUseCase = saveJobUseCase
    }

    func load() async {
        isSaved = await saveJobUseCase.isSaved(job)
    }

    func toggleSaved() async {
        isSaved = (try? await saveJobUseCase.toggle(job)) ?? isSaved
    }
}

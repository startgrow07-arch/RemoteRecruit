//
//  RemoteRecruitApp.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import SwiftUI

@main
struct RemoteRecruitApp: App {
    private let container = AppContainer.makeDefault()

    var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}

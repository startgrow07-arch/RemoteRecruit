//
//  RootView.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import SwiftUI

struct RootView: View {
    let container: AppContainer
    @State private var isShowingSplash = true

    var body: some View {
        Group {
            if isShowingSplash {
                SplashView()
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                MainTabView(container: container)
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1))
            withAnimation(.easeInOut(duration: 0.35)) {
                isShowingSplash = false
            }
        }
    }
}

struct SplashView: View {
    var body: some View {
        VStack(spacing: Spacing.large) {
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.14))
                    .frame(width: 116, height: 116)
                Image(systemName: "briefcase.fill")
                    .font(.system(size: 52, weight: .semibold))
                    .foregroundStyle(.blue)
            }
            VStack(spacing: Spacing.small) {
                Text("RemoteRecruit")
                    .font(.largeTitle.bold())
                Text("Find thoughtful remote work")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("RemoteRecruit, find thoughtful remote work")
    }
}

struct MainTabView: View {
    let container: AppContainer

    var body: some View {
        TabView {
            NavigationStack {
                JobListView(
                    viewModel: JobListViewModel(
                        fetchJobsUseCase: container.fetchJobsUseCase,
                        saveJobUseCase: container.saveJobUseCase,
                        searchHistoryStore: container.searchHistoryStore
                    )
                )
            }
            .tabItem {
                Label("Jobs", systemImage: "list.bullet.rectangle")
            }

            NavigationStack {
                SavedJobsView(
                    viewModel: SavedJobsViewModel(
                        savedJobsUseCase: container.savedJobsUseCase,
                        saveJobUseCase: container.saveJobUseCase
                    )
                )
            }
            .tabItem {
                Label("Saved", systemImage: "bookmark.fill")
            }
        }
    }
}

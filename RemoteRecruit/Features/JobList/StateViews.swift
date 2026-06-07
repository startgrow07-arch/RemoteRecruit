//
//  StateViews.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import SwiftUI

struct LoadingJobsView: View {
    var body: some View {
        VStack(spacing: Spacing.medium) {
            ForEach(0..<6, id: \.self) { _ in
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(.secondary.opacity(0.16))
                    .frame(height: 132)
                    .overlay(alignment: .leading) {
                        HStack(spacing: Spacing.medium) {
                            RoundedRectangle(cornerRadius: AppCornerRadius.small)
                                .fill(.secondary.opacity(0.18))
                                .frame(width: 48, height: 48)
                            VStack(alignment: .leading, spacing: Spacing.small) {
                                Capsule().fill(.secondary.opacity(0.18)).frame(width: 180, height: 16)
                                Capsule().fill(.secondary.opacity(0.14)).frame(width: 120, height: 14)
                                Capsule().fill(.secondary.opacity(0.12)).frame(width: 220, height: 14)
                            }
                        }
                        .padding(Spacing.medium)
                    }
            }
        }
        .accessibilityLabel("Loading jobs")
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String
    var retryTitle: String?
    var retry: (() -> Void)?

    var body: some View {
        VStack(spacing: Spacing.medium) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 56, weight: .semibold))
                .foregroundStyle(.blue)
            Text(title)
                .font(.title3.bold())
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            if let retryTitle, let retry {
                Button(retryTitle, action: retry)
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("retryButton")
            }
        }
        .padding(Spacing.xLarge)
        .frame(maxWidth: .infinity)
    }
}

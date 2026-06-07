//
//  JobDetailView.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import SwiftUI

struct JobDetailView: View {
    @StateObject private var viewModel: JobDetailViewModel
    @Environment(\.openURL) private var openURL

    init(viewModel: JobDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                header
                actionRow
                detailSection("Company", text: viewModel.job.companyDescription)
                detailSection("Description", text: viewModel.job.description)
            }
            .padding(Spacing.medium)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await viewModel.toggleSaved() }
                } label: {
                    Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                }
                .accessibilityLabel(viewModel.isSaved ? "Remove saved job" : "Save job")
                .accessibilityIdentifier("saveJobButton")
            }
        }
        .task { await viewModel.load() }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack(alignment: .top, spacing: Spacing.medium) {
                LogoPlaceholder(companyName: viewModel.job.companyName)
                VStack(alignment: .leading, spacing: Spacing.small) {
                    Text(viewModel.job.title)
                        .font(.title2.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    Text(viewModel.job.companyName)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: Spacing.small) {
                Label(viewModel.job.location, systemImage: "mappin.and.ellipse")
                Label(viewModel.job.salaryRange, systemImage: "dollarsign.circle")
                Label(viewModel.job.jobType, systemImage: "clock")
                Label("Posted \(viewModel.job.postedDate.jobPostedText)", systemImage: "calendar")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(Spacing.medium)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.medium, style: .continuous))
    }

    private var actionRow: some View {
        HStack(spacing: Spacing.medium) {
            ShareLink(item: viewModel.job.applyURL) {
                Label("Share", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .accessibilityIdentifier("shareJobButton")

            Button {
                openURL(viewModel.job.applyURL)
            } label: {
                Label("Apply", systemImage: "arrow.up.right")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("applyButton")
        }
    }

    private func detailSection(_ title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text(title)
                .font(.headline)
            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.medium)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.medium, style: .continuous))
    }
}

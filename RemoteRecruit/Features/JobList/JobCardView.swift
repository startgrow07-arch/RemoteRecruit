//
//  JobCardView.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import SwiftUI

struct JobCardView: View {
    let job: Job
    var isSaved: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.medium) {
            LogoPlaceholder(companyName: job.companyName)

            VStack(alignment: .leading, spacing: Spacing.small) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: Spacing.xSmall) {
                        Text(job.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                        Text(job.companyName)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    Spacer(minLength: Spacing.small)
                    if isSaved {
                        Image(systemName: "bookmark.fill")
                            .foregroundStyle(.blue)
                            .accessibilityHidden(true)
                    }
                }

                Label(job.location, systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: Spacing.small) {
                    Chip(text: job.salaryRange, icon: "dollarsign.circle")
                    Chip(text: job.jobType, icon: "clock")
                }
            }
        }
        .padding(Spacing.medium)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.medium, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: AppCornerRadius.medium, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(job.title) at \(job.companyName), \(job.location), salary \(job.salaryRange)")
        .accessibilityIdentifier("jobCard_\(job.id)")
    }
}

struct LogoPlaceholder: View {
    let companyName: String

    var body: some View {
        Text(String(companyName.prefix(1)).uppercased())
            .font(.title2.bold())
            .frame(width: 48, height: 48)
            .background(.blue.opacity(0.14))
            .foregroundStyle(.blue)
            .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.small, style: .continuous))
            .accessibilityHidden(true)
    }
}

struct Chip: View {
    let text: String
    let icon: String

    var body: some View {
        Label(text, systemImage: icon)
            .font(.caption.weight(.medium))
            .lineLimit(1)
            .padding(.horizontal, Spacing.small)
            .padding(.vertical, Spacing.xSmall)
            .background(Color(.tertiarySystemGroupedBackground))
            .clipShape(Capsule())
    }
}

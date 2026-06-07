//
//  Job.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

struct Job: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let title: String
    let companyName: String
    let companyDescription: String
    let location: String
    let salaryRange: String
    let jobType: String
    let postedDate: Date
    let description: String
    let applyURL: URL

    var searchableText: String {
        "\(title) \(companyName)".lowercased()
    }
}

extension Job {
    private static let previewApplyURL = URL(string: "https://example.com/jobs/senior-ios-engineer") ?? URL(fileURLWithPath: "/")

    static let preview = Job(
        id: "preview-ios-engineer",
        title: "Senior iOS Engineer",
        companyName: "Northstar Labs",
        companyDescription: "A remote-first product studio building practical tools for modern teams.",
        location: "Remote - United States",
        salaryRange: "$145k - $180k",
        jobType: "Full-time",
        postedDate: Date(),
        description: "Lead SwiftUI feature development, shape product architecture, and mentor engineers across a small product team.",
        applyURL: previewApplyURL
    )
}

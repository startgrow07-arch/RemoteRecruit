//
//  RemotiveJobDTO.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

struct RemotiveJobsResponseDTO: Decodable {
    let jobs: [RemotiveJobDTO]
}

struct RemotiveJobDTO: Decodable {
    let id: Int
    let url: URL
    let title: String
    let companyName: String
    let category: String
    let jobType: String
    let publicationDate: Date
    let candidateRequiredLocation: String
    let salary: String?
    let description: String

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case title
        case companyName = "company_name"
        case category
        case jobType = "job_type"
        case publicationDate = "publication_date"
        case candidateRequiredLocation = "candidate_required_location"
        case salary
        case description
    }

    func toDomain() -> Job {
        let salaryText = salary.flatMap { $0.isEmpty ? nil : $0 } ?? "Not disclosed"

        return Job(
            id: "remotive-\(id)",
            title: title,
            companyName: companyName,
            companyDescription: "\(companyName) is hiring for a \(category.lowercased()) role on a remote team.",
            location: candidateRequiredLocation.isEmpty ? "Remote" : candidateRequiredLocation,
            salaryRange: salaryText,
            jobType: jobType,
            postedDate: publicationDate,
            description: description.removingHTMLTags,
            applyURL: url
        )
    }
}

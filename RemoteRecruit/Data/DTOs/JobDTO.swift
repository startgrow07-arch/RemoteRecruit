//
//  JobDTO.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

struct JobDTO: Decodable {
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

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case companyName = "company_name"
        case companyDescription = "company_description"
        case location
        case salaryRange = "salary_range"
        case jobType = "job_type"
        case postedDate = "posted_date"
        case description
        case applyURL = "apply_url"
    }

    func toDomain() -> Job {
        Job(
            id: id,
            title: title,
            companyName: companyName,
            companyDescription: companyDescription,
            location: location,
            salaryRange: salaryRange,
            jobType: jobType,
            postedDate: postedDate,
            description: description,
            applyURL: applyURL
        )
    }
}

struct JobsResponseDTO: Decodable {
    let jobs: [JobDTO]
}

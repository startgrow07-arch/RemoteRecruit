//
//  NetworkError.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case requestFailed
    case decodingFailed
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The jobs endpoint is not configured correctly."
        case .invalidResponse:
            return "The jobs service returned an unexpected response."
        case .requestFailed:
            return "We could not connect to the jobs service."
        case .decodingFailed:
            return "We could not read the jobs response."
        case .noData:
            return "No jobs were returned."
        }
    }
}

//
//  Endpoint.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

struct Endpoint {
    let path: String
    var queryItems: [URLQueryItem] = []

    func url(baseURL: URL) -> URL? {
        var components = URLComponents(url: baseURL.appending(path: path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        return components?.url
    }
}

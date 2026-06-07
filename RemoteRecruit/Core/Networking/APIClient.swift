//
//  APIClient.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

protocol APIClientProtocol {
    func get<Response: Decodable>(_ endpoint: Endpoint, baseURL: URL) async throws -> Response
}

struct URLSessionAPIClient: APIClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get<Response: Decodable>(_ endpoint: Endpoint, baseURL: URL) async throws -> Response {
        guard let url = endpoint.url(baseURL: baseURL) else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }

            do {
                return try JSONDecoder.remoteRecruit.decode(Response.self, from: data)
            } catch {
                throw NetworkError.decodingFailed
            }
        } catch let error as NetworkError {
            throw error
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw NetworkError.requestFailed
        }
    }
}

extension JSONDecoder {
    nonisolated static var remoteRecruit: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

extension JSONEncoder {
    nonisolated static var remoteRecruit: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

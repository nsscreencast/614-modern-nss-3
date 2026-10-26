import Foundation
import OSLog

public struct APIClient {
    let baseURL: URL
    let session: URLSession
    let decoder: JSONDecoder
    let logger = Logger(subsystem: "nsscreencast", category: "APIClient")

    public static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    public init(baseURL: URL = ServerConfiguration.productionBaseURL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session

        self.decoder = Self.decoder
    }

    public func fetchEpisodePage(
        after: String? = nil,
        limit: Int? = nil
    ) async throws -> API.V2.EpisodePage {
        var components = URLComponents(url: baseURL.appendingPathComponent("api/v2/episodes"), resolvingAgainstBaseURL: false)
        components?.queryItems = []
        if let limit {
            components?.queryItems?.append(URLQueryItem(name: "limit", value: String(limit)))
        }

        if let after {
            components?.queryItems?.append(URLQueryItem(name: "after", value: after))
        }

        let url = components!.url!
        let req = URLRequest(url: url)
        do {
            let (data, response) = try await session.data(for: req)

            guard let http = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard 200..<300 ~= http.statusCode else {
                throw APIError.http(http.statusCode)
            }

            let page = try decoder.decode(API.V2.EpisodePage.self, from: data)
            return page
        } catch {
            if let e = error as? DecodingError {
                logger.error("Decoding error: \(e.debugDescription)")
                throw APIError.decodingError(e.localizedDescription)
            } else {
                throw APIError.unhandledError(error)
            }
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidResponse
    case http(Int)
    case decodingError(String)
    case unhandledError(Error)
}

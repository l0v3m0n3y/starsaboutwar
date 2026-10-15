import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error { continuation.resume(throwing: error) }
                else if let data, let response { continuation.resume(returning: (data, response)) }
                else { continuation.resume(throwing: URLError(.unknown)) }
            }
            task.resume()
        }
    }
}
#endif

public enum HTTPMethod: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE", patch = "PATCH"
}

public struct starsAboutWar {
    private let api = "https://starsaboutwar.in.ua/ru"
    private let headers = [
        "Accept-Language": "en-US,en;q=0.9",
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36"
    ]

    public init() {}

    private func fetch(from urlString: String,
                       method: HTTPMethod = .get,
                       body: Data? = nil,
                       query: [URLQueryItem] = []) async throws -> Data {
        guard var components = URLComponents(string: urlString) else { throw URLError(.badURL) }
        if !query.isEmpty { components.queryItems = query }
        guard let url = components.url else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return data
    }

    private func fetchJSON(from urlString: String, query: [URLQueryItem] = []) async throws -> Any {
        let data = try await fetch(from: urlString, query: query)
        return try JSONSerialization.jsonObject(with: data)
    }


    public func getGetStarStats(articleId: Int) async throws -> Any {
        var items: [URLQueryItem] = []
        func add(_ name: String, _ value: CustomStringConvertible?) {
            if let value { items.append(URLQueryItem(name: name, value: value.description)) }
        }
        add("article_id", String(articleId))
        add("option", "com_starpolls")
        add("task", "vote.getStats")
        add("format", "json")

        return try await fetchJSON(from: "\(api)/search", query: items)
    }

    public func searchStar(searchTerm: String) async throws -> Any {
        var items: [URLQueryItem] = []
        func add(_ name: String, _ value: CustomStringConvertible?) {
            if let value { items.append(URLQueryItem(name: name, value: value.description)) }
        }
        add("q", searchTerm)
        add("amp;format", "json")
        add("task", "ajax.search")

        return try await fetchJSON(from: "\(api)/search", query: items)
    }
}

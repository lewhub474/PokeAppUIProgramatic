//
//  NetworkingService.swift.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

final class NetworkingService: NetworkingServiceProtocol {
    func request<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NSError(domain: "Invalid response", code: 0)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

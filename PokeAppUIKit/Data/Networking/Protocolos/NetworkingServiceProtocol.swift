//
//  NetworkingServiceProtocol.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

protocol NetworkingServiceProtocol {
    func request<T: Decodable>(url: URL) async throws -> T
}

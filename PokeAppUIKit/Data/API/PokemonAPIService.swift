//
//  PokemonAPIService.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

final class PokemonAPIService: PokemonAPIServiceProtocol {
    private let baseURL = "https://pokeapi.co/api/v2"
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil // No usar ninguna cache por error a segunda sesion en simulador
        return URLSession(configuration: configuration)
    }()
    
    
    func fetchPokemonList() async throws -> [PokemonListItemDTO] {
        let url = URL(string: "\(baseURL)/pokemon?limit=151")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PokemonListResponse.self, from: data)
        return response.results
    }
    
    func fetchPokemonDetail(for id: Int) async throws -> PokemonDTO {
        let url = URL(string: "\(baseURL)/pokemon/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonDTO.self, from: data)
    }
    
}

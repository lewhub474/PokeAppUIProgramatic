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
    
    func fetchAbilityDetail(for id: Int) async throws -> PokemonAbilityResponse {
        let url = URL(string: "\(baseURL)/ability/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PokemonAbilityResponse.self, from: data)
        return response
    }
    
    func fetchPokemonDetail(for id: Int) async throws -> PokemonDTO {
        let url = URL(string: "\(baseURL)/pokemon/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonDTO.self, from: data)
    }
    
}


struct PokemonListItemDTO: Codable {
    let name: String
    let url: String
}



extension PokemonListItemDTO {
    var id: Int? {
        // Extrae el id del final de la url, ej: "https://pokeapi.co/api/v2/pokemon/1/"
        guard let lastComponent = url.split(separator: "/").last,
              let id = Int(lastComponent) else { return nil }
        return id
    }
}


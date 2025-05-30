//
//  PokemonRepository.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

final class PokemonRepository: PokemonRepositoryProtocol, PokemonDetailRepositoryProtocol {
    private let apiService: PokemonAPIServiceProtocol
    
    init(apiService: PokemonAPIServiceProtocol) {
        self.apiService = apiService
    }
    
    // Implementación lista de pokemons
    func getAllPokemon() async throws -> [Pokemon] {
        let listItems = try await apiService.fetchPokemonList()
        
        let ids = listItems.compactMap { $0.id }
        
        var pokemons: [Pokemon] = []
        
        try await withThrowingTaskGroup(of: Pokemon?.self) { group in
            for id in ids {
                group.addTask {
                    let dto = try await self.apiService.fetchPokemonDetail(for: id)
                    return Pokemon(dto: dto)
                }
            }
            
            for try await pokemon in group {
                if let pokemon = pokemon {
                    pokemons.append(pokemon)
                }
            }
        }
        
        return pokemons.sorted(by: { $0.id < $1.id })
    }
    
    // Implementación async para obtener detalle de Pokémon
    func getPokemonDetail(name: String) async throws -> PokemonDetail {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(name)"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let dto = try JSONDecoder().decode(PokemonDetailDTO.self, from: data)
        return dto.toDomain()
    }
    
    // Obtener habilidad (async)
    func getAbility(for id: Int) async throws -> Ability {
        let response = try await apiService.fetchAbilityDetail(for: id)
        return Ability(response: response)
    }
}


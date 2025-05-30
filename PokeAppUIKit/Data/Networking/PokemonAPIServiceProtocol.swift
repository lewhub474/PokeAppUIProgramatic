//
//  PokemonAPIServiceProtocol.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

protocol PokemonAPIServiceProtocol {
    func fetchPokemonList() async throws -> [PokemonListItemDTO] // 👈 corregido
    func fetchAbilityDetail(for id: Int) async throws -> PokemonAbilityResponse
    func fetchPokemonDetail(for id: Int) async throws -> PokemonDTO
}



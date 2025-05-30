//
//  PokemonAPIServiceProtocol.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

protocol PokemonAPIServiceProtocol {
    func fetchPokemonList() async throws -> [PokemonListItemDTO] 
    func fetchPokemonDetail(for id: Int) async throws -> PokemonDTO
}



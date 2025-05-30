//
//  PokemonRepositoryProtocol.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

protocol PokemonRepositoryProtocol {
    func getAllPokemon() async throws -> [Pokemon]
    func getAbility(for id: Int) async throws -> Ability
}

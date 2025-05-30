//
//  FetchAllpokemonUseCase.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

final class FetchAllPokemonUseCase: FetchAllPokemonUseCaseProtocol {
    private let repository: PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Pokemon] {
        return try await repository.getAllPokemon()
    }
}


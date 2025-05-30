//
//  PokemonDetailViewModel.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

class PokemonDetailViewModel {
    private let useCase: GetPokemonDetailUseCase
    private(set) var pokemonDetail: PokemonDetail?
    
    var onDataUpdated: (() -> Void)?
    
    init(useCase: GetPokemonDetailUseCase) {
        self.useCase = useCase
    }
    
    func fetchDetail(for name: String) {
        Task {
            do {
                let detail = try await useCase.execute(name: name)
                self.pokemonDetail = detail
                onDataUpdated?()
            } catch {
                print("Error fetching Pokémon detail:", error)
            }
        }
    }
}

protocol GetPokemonDetailUseCase {
    func execute(name: String) async throws -> PokemonDetail
}

class GetPokemonDetailUseCaseImpl: GetPokemonDetailUseCase {
    private let repository: PokemonDetailRepositoryProtocol
    
    init(repository: PokemonDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(name: String) async throws -> PokemonDetail {
        try await repository.getPokemonDetail(name: name)
    }
}

protocol PokemonDetailRepositoryProtocol {
    func getPokemonDetail(name: String) async throws -> PokemonDetail
}


//
//  PokemonListViewModel.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

class PokemonListViewModel: PokemonListViewModelProtocol {
    
    func fetchFavoritePokemons() {
            filteredPokemons = pokemons.filter { $0.isFavorite }
            onDataUpdated?()
        }
    
    func toggleFavorite(for pokemon: Pokemon) {
        if let index = pokemons.firstIndex(where: { $0.name == pokemon.name }) {
            pokemons[index].isFavorite.toggle()
        }

        if let index = filteredPokemons.firstIndex(where: { $0.name == pokemon.name }) {
            filteredPokemons[index].isFavorite.toggle()
        }

        onDataUpdated?()
    }

    private let fetchAllPokemonUseCase: FetchAllPokemonUseCaseProtocol
    
    private(set) var pokemons: [Pokemon] = []
    private(set) var filteredPokemons: [Pokemon] = []
    var onDataUpdated: (() -> Void)?
    
    init(fetchAllPokemonUseCase: FetchAllPokemonUseCaseProtocol) {
        self.fetchAllPokemonUseCase = fetchAllPokemonUseCase
    }
    
    func fetchPokemons() {
        Task {
            do {
                let result = try await fetchAllPokemonUseCase.execute()
                DispatchQueue.main.async {
                    self.pokemons = result
                    self.filteredPokemons = result
                    self.onDataUpdated?()
                }
            } catch {
                print("Error fetching Pokémon list:", error)
                // Aquí podrías notificar al VC sobre el error
            }
        }
    }
    
    func search(with query: String) {
        if query.isEmpty {
            filteredPokemons = pokemons
        } else {
            filteredPokemons = pokemons.filter {
                $0.name.lowercased().contains(query.lowercased())
            }
        }
        onDataUpdated?()
    }
}

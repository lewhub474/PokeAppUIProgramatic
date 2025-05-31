//
//  PokemonListViewModel.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

class PokemonListViewModel: PokemonListViewModelProtocol {
    private let favoriteRepository: FavoritePokemonRepositoryProtocol

    func fetchFavoritePokemons() {
            filteredPokemons = pokemons.filter { $0.isFavorite }
            onDataUpdated?()
        }
    
    func toggleFavorite(for pokemon: Pokemon) {
        if let index = pokemons.firstIndex(where: { $0.name == pokemon.name }) {
            pokemons[index].isFavorite.toggle()
            print("🔥 se presionó botón de este pokemon \(pokemon.name)")

            if pokemons[index].isFavorite {
                let favorite = FavoritePokemon(value: [
                    "id": pokemon.id,
                    "name": pokemon.name,
                    "imageURL": pokemon.imageURL
                ])
                favoriteRepository.add(favorite)
                print("✅ Guardado en favoritos (Realm): \(pokemon.name)")
            } else {
                favoriteRepository.remove(id: pokemon.id)
                print("🗑️ Removido de favoritos (Realm): \(pokemon.name)")
            }
        }

        if let index = filteredPokemons.firstIndex(where: { $0.name == pokemon.name }) {
            filteredPokemons[index].isFavorite.toggle()
        }

        onDataUpdated?()
    }

//    func toggleFavorite(for pokemon: Pokemon) {
//        if let index = pokemons.firstIndex(where: { $0.name == pokemon.name }) {
//            pokemons[index].isFavorite.toggle()
//            print("🔥 se presiono boton de este pokemon \(pokemon.name)")
//        }
//
//        if let index = filteredPokemons.firstIndex(where: { $0.name == pokemon.name }) {
//            filteredPokemons[index].isFavorite.toggle()
//        }
//
//        onDataUpdated?()
//    }

    private let fetchAllPokemonUseCase: FetchAllPokemonUseCaseProtocol
    
    private(set) var pokemons: [Pokemon] = []
    private(set) var filteredPokemons: [Pokemon] = []
    var onDataUpdated: (() -> Void)?
    
    init(fetchAllPokemonUseCase: FetchAllPokemonUseCaseProtocol, favoriteRepository: FavoritePokemonRepositoryProtocol) {
        self.fetchAllPokemonUseCase = fetchAllPokemonUseCase
        self.favoriteRepository = favoriteRepository
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

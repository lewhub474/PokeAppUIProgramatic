//
//  PokemonListViewModel.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

class PokemonListViewModel: PokemonListViewModelProtocol {
    private let favoriteRepository: FavoritePokemonRepositoryProtocol
    private let fetchAllPokemonUseCase: FetchAllPokemonUseCaseProtocol
    
    private(set) var pokemons: [Pokemon] = []
    private(set) var filteredPokemons: [Pokemon] = []
    var onDataUpdated: (() -> Void)?
    
    init(fetchAllPokemonUseCase: FetchAllPokemonUseCaseProtocol,
         favoriteRepository: FavoritePokemonRepositoryProtocol) {
        self.fetchAllPokemonUseCase = fetchAllPokemonUseCase
        self.favoriteRepository = favoriteRepository
    }
    
    func fetchPokemons() {
        Task {
            do {
                let result = try await fetchAllPokemonUseCase.execute()
                let syncedPokemons = result.map { pokemon -> Pokemon in
                    var mutablePokemon = pokemon
                    mutablePokemon.isFavorite = favoriteRepository.isFavorite(id: pokemon.id)
                    return mutablePokemon
                }
                
                DispatchQueue.main.async {
                    self.pokemons = syncedPokemons
                    self.filteredPokemons = syncedPokemons
                    self.onDataUpdated?()
                }
            } catch {
                print("Error fetching Pokémon list:", error)
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
    
    func fetchFavoritePokemons() {
        filteredPokemons = pokemons.filter { $0.isFavorite }
        onDataUpdated?()
    }
    
    func toggleFavorite(for pokemon: Pokemon) {
        guard let index = pokemons.firstIndex(where: { $0.id == pokemon.id }) else { return }
        
        pokemons[index].isFavorite.toggle()
        let isFavoriteNow = pokemons[index].isFavorite
        
        if isFavoriteNow {
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
        
        if let filteredIndex = filteredPokemons.firstIndex(where: { $0.id == pokemon.id }) {
            filteredPokemons[filteredIndex].isFavorite = isFavoriteNow
        }
        
        onDataUpdated?()
    }
}

//
//  PokemonCellListViewModel.swift
//  PokeAppUIKit
//
//  Created by Macky on 30/05/25.
//


import Foundation

class PokemonCellListViewModel {
    private let pokemon: Pokemon
    private let favoritesRepository: FavoritePokemonRepositoryProtocol

    var name: String {
        pokemon.name.capitalized
    }

    var imageURL: String {
        pokemon.imageURL
    }

    var isFavorite: Bool {
        favoritesRepository.isFavorite(id: pokemon.id)
    }

    init(pokemon: Pokemon, favoritesRepository: FavoritePokemonRepositoryProtocol) {
        self.pokemon = pokemon
        self.favoritesRepository = favoritesRepository
    }

    func toggleFavorite() {
        if isFavorite {
            favoritesRepository.remove(id: pokemon.id)
        } else {
            let favorite = FavoritePokemon(value: [
                "id": pokemon.id,
                "name": pokemon.name,
                "imageURL": pokemon.imageURL
            ])
            favoritesRepository.add(favorite)
        }
    }
}



//
//  s.swift
//  PokeAppUIKit
//
//  Created by Macky on 31/05/25.
//

protocol FavoritePokemonRepositoryProtocol {
    func isFavorite(id: Int) -> Bool
    func add(_ pokemon: FavoritePokemon)
    func remove(id: Int)
    func getAllFavorites() -> [FavoritePokemon]
}

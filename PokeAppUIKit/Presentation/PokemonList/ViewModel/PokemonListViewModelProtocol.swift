//
//  Untitled.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

protocol PokemonListViewModelProtocol {
    var pokemons: [Pokemon] { get }
    var filteredPokemons: [Pokemon] { get }
    var onDataUpdated: (() -> Void)? { get set }
    
    func fetchPokemons()
    func fetchFavoritePokemons()
    func search(with query: String)
    func toggleFavorite(for pokemon: Pokemon)
}

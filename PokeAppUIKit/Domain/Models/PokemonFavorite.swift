//
//  PokemonFavorite.swift
//  PokeAppUIKit
//
//  Created by Macky on 30/05/25.
//

import RealmSwift

class FavoritePokemon: Object {
    @Persisted(primaryKey: true) var id: Int 
    @Persisted var name: String
    @Persisted var imageURL: String?
}

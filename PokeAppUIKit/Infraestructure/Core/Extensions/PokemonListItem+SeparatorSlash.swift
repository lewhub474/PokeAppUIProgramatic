//
//  PokemonListItem+SeparatorSlash.swift
//  PokeAppUIKit
//
//  Created by Macky on 31/05/25.
//

extension PokemonListItemDTO {
    var id: Int? {
        guard let lastComponent = url.split(separator: "/").last,
              let id = Int(lastComponent) else { return nil }
        return id
    }
}


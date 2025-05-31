//
//  Pokemon.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

struct Pokemon {
    let id: Int
    let name: String
    let imageURL: String
    let types: [String]
    let stats: [Stat]
    var isFavorite: Bool = false
    
    init(dto: PokemonDTO) {
        self.id = dto.id
        self.name = dto.name
        self.imageURL = dto.sprites.frontDefault
        self.types = dto.types.map { $0.type.name }
        self.stats = dto.stats.map { Stat(dto: $0) }
    }
    
    init(id: Int, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.types = []
        self.stats = []
    }
}

struct Stat {
    let name: String
    let value: Int
    
    init(dto: StatEntryDTO) {
        self.name = dto.stat.name
        self.value = dto.baseStat
    }
}


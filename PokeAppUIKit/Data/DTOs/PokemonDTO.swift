//
//  PokemonDTO.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

struct PokemonDTO: Decodable {
    let id: Int
    let name: String
    let sprites: SpritesDTO
    let types: [TypeEntryDTO]
    let stats: [StatEntryDTO]
    let abilities: [AbilityEntryDTO]
}

struct SpritesDTO: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct TypeEntryDTO: Decodable {
    let type: NamedAPIResourceDTO
}

struct StatEntryDTO: Decodable {
    let baseStat: Int
    let stat: NamedAPIResourceDTO
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct AbilityEntryDTO: Decodable {
    let ability: NamedAPIResourceDTO
}

struct NamedAPIResourceDTO: Decodable {
    let name: String
    let url: String
}

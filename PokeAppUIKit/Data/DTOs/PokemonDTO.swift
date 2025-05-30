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
}

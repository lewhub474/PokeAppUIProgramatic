//
//  PokemonDTO.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//
import Foundation

struct PokemonAbilityResponse: Decodable {
    let id: Int
    let name: String
    let effectEntries: [EffectEntry]
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case effectEntries = "effect_entries"
    }
}

struct EffectEntry: Decodable {
    let effect: String
    let language: Language
}

struct Language: Decodable {
    let name: String
}

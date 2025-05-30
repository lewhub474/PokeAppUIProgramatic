//
//  PokemonDetailDTO.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

struct PokemonDetailDTO: Decodable {
    let id: Int
    let name: String
    let sprites: Sprites
    let types: [TypeEntry]
    let abilities: [AbilityEntry]
    let stats: [StatEntry]
    
    struct Sprites: Decodable {
        let frontDefault: String
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    
    struct TypeEntry: Decodable {
        let type: TypeInfo
        
        struct TypeInfo: Decodable {
            let name: String
        }
    }
    
    struct AbilityEntry: Decodable {
        let ability: AbilityInfo
        
        struct AbilityInfo: Decodable {
            let name: String
        }
    }
    
    struct StatEntry: Decodable {
        let baseStat: Int
        let stat: StatInfo
        
        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case stat
        }
        
        struct StatInfo: Decodable {
            let name: String
        }
    }
    
    func toDomain() -> PokemonDetail {
        let domainStats = stats.map { PokemonStat(name: $0.stat.name, value: $0.baseStat) }
        let domainAbilities = abilities.map { $0.ability.name }
        let domainTypes = types.map { $0.type.name }
        
        return PokemonDetail(
            id: id,
            name: name.capitalized,
            imageUrl: sprites.frontDefault,
            types: domainTypes,
            stats: domainStats,
            abilities: domainAbilities,
            evolutions: [] // Lo de evoluciones luego
        )
    }
}

struct PokemonDetail {
    let id: Int
    let name: String
    let imageUrl: String
    let types: [String]
    let stats: [PokemonStat]
    let abilities: [String]
    let evolutions: [String]
}

struct PokemonStat {
    let name: String
    let value: Int
}

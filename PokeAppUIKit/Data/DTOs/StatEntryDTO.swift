//
//  StatEntryDTO.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

struct StatEntryDTO: Decodable {
    let baseStat: Int
    let stat: NamedAPIResourceDTO
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

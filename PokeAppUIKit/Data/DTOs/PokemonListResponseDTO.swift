//
//  PokemonListResponseDTO.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

struct PokemonListResponseDTO: Decodable {
    let results: [PokemonDTO]
}


struct PokemonListResponse: Codable {
    let results: [PokemonListItemDTO]
}

struct PokemonListItem: Codable {
    let name: String
    let url: String
    
    var id: Int? {
        // La url termina con /pokemon/{id}/
        guard let lastComponent = url.split(separator: "/").last,
              let id = Int(lastComponent) else {
            return nil
        }
        return id
    }
}


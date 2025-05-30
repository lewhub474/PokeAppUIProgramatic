//
//  Sprites.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

struct Sprites: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

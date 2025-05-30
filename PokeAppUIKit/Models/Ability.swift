//
//  Ability.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

struct Ability {
    let id: Int
    let name: String
    let effect: String
    
    init(response: PokemonAbilityResponse) {
        self.id = response.id
        self.name = response.name.capitalized
        
        // Buscamos el efecto en inglés
        self.effect = response.effectEntries.first(where: { $0.language.name == "en" })?.effect ?? "No description available"
    }
}

//
//  Maper.swift
//  PokeAppUIKit
//
//  Created by Macky on 30/05/25.
//

extension PokemonDetail {
    init(dto: PokemonDTO) {
        self.id = dto.id
        self.name = dto.name.capitalized
        self.imageUrl = dto.sprites.frontDefault
        self.types = dto.types.map { $0.type.name }
        self.stats = dto.stats.map {
            PokemonStat(name: $0.stat.name, value: $0.baseStat)
        }
        self.evolutions = [] // Si luego usas otro DTO para esto, lo completas aquí
    }
}

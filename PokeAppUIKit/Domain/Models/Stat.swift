//
//  Stat.swift
//  PokeAppUIKit
//
//  Created by Macky on 31/05/25.
//

struct Stat {
    let name: String
    let value: Int
    
    init(dto: StatEntryDTO) {
        self.name = dto.stat.name
        self.value = dto.baseStat
    }
}


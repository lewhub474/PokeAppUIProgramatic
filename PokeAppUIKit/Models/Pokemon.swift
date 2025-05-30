//
//  Pokemon.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

struct Pokemon {
    let id: Int
    let name: String
    let imageURL: String
    let types: [String]
    let stats: [Stat]
    let abilities: [String]
    
    // Init desde DTO (ya lo tienes)
    init(dto: PokemonDTO) {
        self.id = dto.id
        self.name = dto.name
        self.imageURL = dto.sprites.frontDefault
        self.types = dto.types.map { $0.type.name }
        self.stats = dto.stats.map { Stat(dto: $0) }
        self.abilities = dto.abilities.map { $0.ability.name }
    }
    
    // Init adicional para usar desde la lista
    init(id: Int, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.types = []
        self.stats = []
        self.abilities = []
    }
}

struct Stat {
    let name: String
    let value: Int
    
    init(dto: StatEntryDTO) {
        self.name = dto.stat.name
        self.value = dto.baseStat
    }
}

import UIKit

// MARK: Mover extension de UIImageView
extension UIImageView {
    func loadImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = nil
            return
        }
        
        // Descargar en background
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }
    }
}



//
//  FetchAllPokemonUseCaseProtocol.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import Foundation

protocol FetchAllPokemonUseCaseProtocol {
    func execute() async throws -> [Pokemon]
}

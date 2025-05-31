//
//  Combine.swift
//  PokeAppUIKit
//
//  Created by Macky on 30/05/25.
//

import Combine


final class FavoriteEvents {
    static let shared = FavoriteEvents()
    let favoritesDidChange = PassthroughSubject<Void, Never>()
    private init() {}
}

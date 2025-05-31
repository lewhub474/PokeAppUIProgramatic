//
//  FavoritesViewModel.swift
//  PokeAppUIKit
//
//  Created by Macky on 31/05/25.
//

import Foundation
import Combine
import RealmSwift

final class FavoritesViewModel: ObservableObject {
     let repository: FavoritePokemonRepositoryProtocol
    private var notificationToken: NotificationToken?
    private var realm: Realm

    @Published var favorites: [Pokemon] = []

    init(repository: FavoritePokemonRepositoryProtocol) {
        self.repository = repository
        self.realm = try! Realm()
        observeFavorites()
        loadFavorites() //
    }

    private func observeFavorites() {
        let results = realm.objects(FavoritePokemon.self)
        notificationToken = results.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(let favorites):
                self.favorites = favorites.map { Pokemon(id: $0.id, name: $0.name, imageURL: $0.imageURL ?? "") }
            case .update(let favorites, _, _, _):
                self.favorites = favorites.map { Pokemon(id: $0.id, name: $0.name, imageURL: $0.imageURL ?? "") }
            case .error(let error):
                print("Error observing favorites: \(error)")
            }
        }
    }
    
    func toggleFavorite(for pokemon: Pokemon) {
        if repository.isFavorite(id: pokemon.id) {
            repository.remove(id: pokemon.id)
        } else {
            let favorite = FavoritePokemon(value: [
                "id": pokemon.id,
                "name": pokemon.name,
                "imageURL": pokemon.imageURL
            ])
            repository.add(favorite)
            print("🔥 Guardado como favorito: \(pokemon.name)")
        }
    }
    
    func loadFavorites() {
        do {
            let realm = try Realm()
            let favoritos = realm.objects(FavoritePokemon.self)
            self.favorites = favoritos.map {
                Pokemon(id: $0.id, name: $0.name, imageURL: $0.imageURL ?? "")
            }
            print("Favoritos cargados: \(favorites.map { $0.name })")
        } catch {
            print("Error al cargar favoritos: \(error.localizedDescription)")
        }
    }



    deinit {
        notificationToken?.invalidate()
    }
}

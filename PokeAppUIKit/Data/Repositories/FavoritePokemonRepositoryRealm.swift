//
//  FavoritePokemonRepositoryRealm.swift
//  PokeAppUIKit
//
//  Created by Macky on 31/05/25.
//
import RealmSwift
import Foundation

class FavoritePokemonRepositoryRealm: FavoritePokemonRepositoryProtocol {

    func isFavorite(id: Int) -> Bool {
        do {
            let realm = try Realm()
            return realm.object(ofType: FavoritePokemon.self, forPrimaryKey: id) != nil
        } catch {
            print("Error opening Realm: \(error)")
            return false
        }
    }

    func add(_ pokemon: FavoritePokemon) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(pokemon, update: .modified)
            }
            let allFavorites = realm.objects(FavoritePokemon.self)
            print("Current favorites: \(allFavorites)")
        } catch {
            print("Error adding favorite: \(error)")
        }
    }

    func remove(id: Int) {
        do {
            let realm = try Realm()
            if let object = realm.object(ofType: FavoritePokemon.self, forPrimaryKey: id) {
                try realm.write {
                    realm.delete(object)
                }
            }
        } catch {
            print("Error removing favorite: \(error)")
        }
    }

    func getAllFavorites() -> [FavoritePokemon] {
        do {
            let realm = try Realm()
            return Array(realm.objects(FavoritePokemon.self))
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
}


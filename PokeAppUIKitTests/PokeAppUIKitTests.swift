//
//  PokeAppUIKitTests.swift
//  PokeAppUIKitTests
//
//  Created by Macky on 27/05/25.
//

import XCTest
import RealmSwift
@testable import PokeAppUIKit

class RealmTestCase: XCTestCase {
    var realm: Realm!

    override func setUpWithError() throws {
        var config = Realm.Configuration()
        config.inMemoryIdentifier = self.name
        realm = try Realm(configuration: config)
    }

    override func tearDownWithError() throws {
        realm = nil
    }
}

class TestableFavoritePokemonRepositoryRealm: FavoritePokemonRepositoryRealm {
    private let testRealm: Realm

    init(realm: Realm) {
        self.testRealm = realm
    }

    override func isFavorite(id: Int) -> Bool {
        return testRealm.object(ofType: FavoritePokemon.self, forPrimaryKey: id) != nil
    }

    override func add(_ pokemon: FavoritePokemon) {
        try? testRealm.write {
            testRealm.add(pokemon, update: .modified)
        }
    }

    override func remove(id: Int) {
        if let object = testRealm.object(ofType: FavoritePokemon.self, forPrimaryKey: id) {
            try? testRealm.write {
                testRealm.delete(object)
            }
        }
    }

    override func getAllFavorites() -> [FavoritePokemon] {
        return Array(testRealm.objects(FavoritePokemon.self))
    }
}

final class FavoritePokemonRepositoryRealmTests: RealmTestCase {

    var repository: TestableFavoritePokemonRepositoryRealm!

    override func setUpWithError() throws {
        try super.setUpWithError()
        repository = TestableFavoritePokemonRepositoryRealm(realm: realm)
    }

    func testAddFavorite() {
        let pokemon = FavoritePokemon()
        pokemon.id = 1
        pokemon.name = "Bulbasaur"
        pokemon.imageURL = "https://example.com/bulbasaur.png"

        repository.add(pokemon)

        let stored = repository.isFavorite(id: 1)
        XCTAssertTrue(stored, "Bulbasaur should be marked as favorite")
    }

    func testRemoveFavorite() {
        let pokemon = FavoritePokemon()
        pokemon.id = 2
        pokemon.name = "Charmander"
        pokemon.imageURL = "https://example.com/charmander.png"

        repository.add(pokemon)
        repository.remove(id: 2)

        let stillFavorite = repository.isFavorite(id: 2)
        XCTAssertFalse(stillFavorite, "Charmander should have been removed")
    }

    func testGetAllFavorites() {
        let pokemon1 = FavoritePokemon(value: ["id": 3, "name": "Squirtle", "imageURL": ""])
        let pokemon2 = FavoritePokemon(value: ["id": 4, "name": "Pikachu", "imageURL": ""])

        repository.add(pokemon1)
        repository.add(pokemon2)

        let favorites = repository.getAllFavorites()
        XCTAssertEqual(favorites.count, 2)
        XCTAssertTrue(favorites.contains(where: { $0.name == "Squirtle" }))
        XCTAssertTrue(favorites.contains(where: { $0.name == "Pikachu" }))
    }
}

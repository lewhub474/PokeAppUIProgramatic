//
//  PokemonFavorite.swift
//  PokeAppUIKit
//
//  Created by Macky on 30/05/25.
//

import RealmSwift

class FavoritePokemon: Object {
    @Persisted(primaryKey: true) var id: Int           // coincide con el id del Pokémon
    @Persisted var name: String
    @Persisted var imageURL: String?
}


//protocol FavoritesRepositoryProtocol {
//    func getAll() -> Results<FavoritePokemon>
//    func isFavorite(id: Int) -> Bool
//    func add(_ pokemon: FavoritePokemon)
//    func remove(id: Int)
//}

//class FavoritesRepository: FavoritesRepositoryProtocol {
//    private let realm = try! Realm()
//    
//    func getAll() -> Results<FavoritePokemon> {
//        realm.objects(FavoritePokemon.self)
//    }
//    
//    func isFavorite(id: Int) -> Bool {
//        realm.object(ofType: FavoritePokemon.self, forPrimaryKey: id) != nil
//    }
//    
//    func add(_ pokemon: FavoritePokemon) {
//        try? realm.write {
//            realm.add(pokemon, update: .modified)
//        }
//    }
//    
//    func remove(id: Int) {
//        if let obj = realm.object(ofType: FavoritePokemon.self, forPrimaryKey: id) {
//            try? realm.write {
//                realm.delete(obj)
//            }
//        }
//    }
//}

import Foundation
import RealmSwift

protocol FavoritePokemonRepositoryProtocol {
    func isFavorite(id: Int) -> Bool
    func add(_ pokemon: FavoritePokemon)
    func remove(id: Int)
    func getAllFavorites() -> [FavoritePokemon]
}

class FavoritePokemonRepositoryRealm: FavoritePokemonRepositoryProtocol {
    private let realm = try! Realm()

    func isFavorite(id: Int) -> Bool {
        return realm.object(ofType: FavoritePokemon.self, forPrimaryKey: id) != nil
    }

    func add(_ pokemon: FavoritePokemon) {
        try? realm.write {
            realm.add(pokemon, update: .modified)
        }
    }

    func remove(id: Int) {
        if let object = realm.object(ofType: FavoritePokemon.self, forPrimaryKey: id) {
            try? realm.write {
                realm.delete(object)
            }
        }
    }

    func getAllFavorites() -> [FavoritePokemon] {
        return Array(realm.objects(FavoritePokemon.self))
    }
}

import Foundation

final class FavoritesViewModel {
    private let repository: FavoritePokemonRepositoryProtocol

    init(repository: FavoritePokemonRepositoryProtocol) {
        self.repository = repository
    }

    func fetchFavorites() -> [Pokemon] {
        let favoritePokemons = repository.getAllFavorites()
        return favoritePokemons.map { fav in
            Pokemon(id: fav.id, name: fav.name, imageURL: fav.imageURL ?? "/")
        }
    }
}


import UIKit

final class FavoritesViewController: UIViewController {

    private let viewModel: FavoritesViewModel
    private var favorites: [Pokemon] = []

    private let tableView = UITableView()

    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favoritos"
        view.backgroundColor = .systemBackground
        setupTableView()
        loadFavorites()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(PokemonCellListView.self, forCellReuseIdentifier: PokemonCellListView.identifier)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func loadFavorites() {
        favorites = viewModel.fetchFavorites()
        tableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCellListView.identifier, for: indexPath) as? PokemonCellListView else {
            return UITableViewCell()
        }
        let favoritesRepository = FavoritePokemonRepositoryRealm()
        let pokemon = favorites[indexPath.row]
        let cellViewModel = PokemonCellListViewModel(
            pokemon: pokemon,
            favoritesRepository: favoritesRepository
        )

        cell.configure(
            with: pokemon,
            isFavorite: cellViewModel.isFavorite,
            toggleAction: { [weak self] in
                cellViewModel.toggleFavorite()
                self?.loadFavorites()
            }
        )
        return cell
    }

}

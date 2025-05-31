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
        do {
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


import Combine

final class FavoritesViewModel: ObservableObject {
     let repository: FavoritePokemonRepositoryProtocol
    private var notificationToken: NotificationToken?
    private var realm: Realm

    @Published var favorites: [Pokemon] = []

    init(repository: FavoritePokemonRepositoryProtocol) {
        self.repository = repository
        self.realm = try! Realm()
        observeFavorites()
        loadFavorites() // <- Agregado aquí
    }

    
//    init(repository: FavoritePokemonRepositoryProtocol) {
//        self.repository = repository
//        self.realm = try! Realm()
//        observeFavorites()
//    }

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



import UIKit


import Combine

final class FavoritesViewController: UIViewController {
    private let viewModel: FavoritesViewModel
    private var favorites: [Pokemon] = []
    private var cancellables = Set<AnyCancellable>()

    private let tableView = UITableView()

    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        viewModel.$favorites
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                self?.favorites = favorites
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favoritos"
        view.backgroundColor = .systemBackground
        setupTableView()
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
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCellListView.identifier, for: indexPath) as? PokemonCellListView else {
            return UITableViewCell()
        }

        let pokemon = favorites[indexPath.row]
        let isFavorite = viewModel.repository.isFavorite(id: pokemon.id)

        cell.configure(
            with: pokemon,
            isFavorite: isFavorite,
            toggleAction: { [weak self] in
                self?.viewModel.toggleFavorite(for: pokemon)
            }
        )
        return cell
    }
}

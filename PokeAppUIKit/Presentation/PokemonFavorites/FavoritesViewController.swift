//
//  FavoritesViewController.swift
//  PokeAppUIKit
//
//  Created by Macky on 31/05/25.
//

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


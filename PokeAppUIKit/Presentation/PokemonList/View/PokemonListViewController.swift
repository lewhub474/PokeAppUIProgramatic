//
//  PokemonListViewController.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import UIKit

//class PokemonListViewController: UIViewController {
//    
//    private let tableView = UITableView()
//    private let searchController = UISearchController(searchResultsController: nil)
//    private var viewModel: PokemonListViewModelProtocol
//    private let repository: PokemonRepository
//    
//    init(viewModel: PokemonListViewModelProtocol, repository: PokemonRepository) {
//        self.viewModel = viewModel
//        self.repository = repository
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupBindings()
//        viewModel.fetchPokemons()
//    }
//    
//    private func setupUI() {
//        title = "Pokédex"
//        view.backgroundColor = .white
//        
//        // Setup Search Controller
//        navigationItem.searchController = searchController
//        searchController.searchBar.delegate = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        
//        // Setup TableView
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(PokemonCellListView.self, forCellReuseIdentifier: PokemonCellListView.identifier)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    private func setupBindings() {
//        viewModel.onDataUpdated = { [weak self] in
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
//    }
//}

// MARK: - UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate

//extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        viewModel.filteredPokemons.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCellListView.identifier, for: indexPath) as? PokemonCellListView else {
//            return UITableViewCell()
//        }
//        
//        let pokemon = viewModel.filteredPokemons[indexPath.row]
//        cell.configure(with: pokemon)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedPokemon = viewModel.filteredPokemons[indexPath.row]
//        let useCase = GetPokemonDetailUseCaseImpl(repository: repository)
//        let detailViewModel = PokemonDetailViewModel(useCase: useCase)
//        let detailVC = PokemonDetailViewController(viewModel: detailViewModel)
//        
//        navigationController?.pushViewController(detailVC, animated: true)
//        detailViewModel.fetchDetail(for: selectedPokemon.name)
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel.search(with: searchText)
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        viewModel.search(with: "")
//    }
//}

import UIKit

class PokemonListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var viewModel: PokemonListViewModelProtocol
    private let repository: PokemonRepository
    private let showFavorites: Bool

    init(viewModel: PokemonListViewModelProtocol, repository: PokemonRepository, showFavorites: Bool) {
        self.viewModel = viewModel
        self.repository = repository
        self.showFavorites = showFavorites
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        
        if showFavorites {
            viewModel.fetchFavoritePokemons()
        } else {
            viewModel.fetchPokemons()
        }
    }
    
    private func setupUI() {
        title = showFavorites ? "Favoritos" : "Pokédex"
        view.backgroundColor = .white
        
        // Setup Search Controller
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        // Setup TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PokemonCellListView.self, forCellReuseIdentifier: PokemonCellListView.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate

extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredPokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PokemonCellListView.identifier,
            for: indexPath
        ) as? PokemonCellListView else {
            return UITableViewCell()
        }
        
        let pokemon = viewModel.filteredPokemons[indexPath.row]
        
        cell.configure(with: pokemon, isFavorite: pokemon.isFavorite) {
            self.viewModel.toggleFavorite(for: pokemon)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemon = viewModel.filteredPokemons[indexPath.row]
        let useCase = GetPokemonDetailUseCaseImpl(repository: repository)
        let detailViewModel = PokemonDetailViewModel(useCase: useCase)
        let detailVC = PokemonDetailViewController(viewModel: detailViewModel)
        
        navigationController?.pushViewController(detailVC, animated: true)
        detailViewModel.fetchDetail(for: selectedPokemon.name)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(with: "")
    }
}

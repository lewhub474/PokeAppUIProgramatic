//
//  PokemonCellListView.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import UIKit

class PokemonCellListView: UITableViewCell {
    static let identifier = "PokemonCellListView"
    
    private let pokemonImageView = UIImageView()
    private let nameLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    
    private var isFavorite = false
    private var toggleFavoriteAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pokemonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 50),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            favoriteButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            contentView.topAnchor.constraint(equalTo: pokemonImageView.topAnchor, constant: -8),
            contentView.bottomAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 8)
        ])
        
        pokemonImageView.contentMode = .scaleAspectFit
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    func configure(with pokemon: Pokemon, isFavorite: Bool, toggleAction: @escaping () -> Void) {
        nameLabel.text = pokemon.name.capitalized
        pokemonImageView.loadImage(from: pokemon.imageURL)
        
        self.isFavorite = isFavorite
        self.toggleFavoriteAction = toggleAction
        
        updateFavoriteButtonImage()
    }
    
    private func updateFavoriteButtonImage() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemRed : .lightGray
    }
    
    @objc private func favoriteButtonTapped() {
        isFavorite.toggle()
        updateFavoriteButtonImage()
        toggleFavoriteAction?()
    }
}


//class PokemonCellListView: UITableViewCell {
//    static let identifier = "PokemonCellListView"
//    
//    private let pokemonImageView = UIImageView()
//    private let nameLabel = UILabel()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupViews() {
//        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        contentView.addSubview(pokemonImageView)
//        contentView.addSubview(nameLabel)
//        
//        // Layout sencillo
//        NSLayoutConstraint.activate([
//            // Ya existentes
//            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            pokemonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            pokemonImageView.widthAnchor.constraint(equalToConstant: 50),
//            pokemonImageView.heightAnchor.constraint(equalToConstant: 50),
//            
//            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
//            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            
//            contentView.topAnchor.constraint(equalTo: pokemonImageView.topAnchor, constant: -8),
//            contentView.bottomAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 8)
//        ])
//        
//        pokemonImageView.contentMode = .scaleAspectFit
//    }
//    
//    func configure(with pokemon: Pokemon) {
//        nameLabel.text = pokemon.name.capitalized
//        pokemonImageView.loadImage(from: pokemon.imageURL)
//    }
//    
//}

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiService = PokemonAPIService()
        let repository = PokemonRepository(apiService: apiService)
        let fetchUseCase = FetchAllPokemonUseCase(repository: repository)
        let viewModelAll = PokemonListViewModel(fetchAllPokemonUseCase: fetchUseCase)
        
        let allVC = UINavigationController(rootViewController: PokemonListViewController(
            viewModel: viewModelAll,
            repository: repository,
            showFavorites: false)
        )
        allVC.tabBarItem = UITabBarItem(title: "Todos", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        let favoritesRepository = FavoritePokemonRepositoryRealm()
        let favoritesViewModel = FavoritesViewModel(repository: favoritesRepository)
        let favoritesVC = FavoritesViewController(viewModel: favoritesViewModel)
        
        let favNav = UINavigationController(rootViewController: favoritesVC)
        favNav.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "heart.fill"), tag: 1)
        
        viewControllers = [allVC, favNav]
    }

}

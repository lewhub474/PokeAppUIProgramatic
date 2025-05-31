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
        
        toggleFavoriteAction = toggleAction
        updateFavoriteButtonImage(isFavorite: isFavorite)
    }
    
    private func updateFavoriteButtonImage(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemRed : .lightGray
    }
    
    @objc private func favoriteButtonTapped() {
        toggleFavoriteAction?()
    }
}


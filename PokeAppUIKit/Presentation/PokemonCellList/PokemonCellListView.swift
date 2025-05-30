//
//  PokemonCellList.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import UIKit

class PokemonCellList: UITableViewCell {
    static let identifier = "PokemonCell"
    
    private let pokemonImageView = UIImageView()
    private let nameLabel = UILabel()
    
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
        
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(nameLabel)
        
        // Layout sencillo
        NSLayoutConstraint.activate([
            // Ya existentes
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pokemonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 50),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.topAnchor.constraint(equalTo: pokemonImageView.topAnchor, constant: -8),
            contentView.bottomAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 8)
        ])
        
        pokemonImageView.contentMode = .scaleAspectFit
    }
    
    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        pokemonImageView.loadImage(from: pokemon.imageURL)
    }
    
}

//
//  PokemonDetailViewController.swift
//  PokeAppUIKit
//
//  Created by Macky on 29/05/25.
//

import UIKit
import Combine
import UIKit

class PokemonDetailViewController: UIViewController {
    private let viewModel: PokemonDetailViewModel
    
    private let nameLabel = UILabel()
    private let imageView = UIImageView()
    private let typesLabel = UILabel()
    private let statsLabel = UILabel()
    private let abilitiesLabel = UILabel()
    private let evolutionsLabel = UILabel()
    
    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bind()
    }
    
    private func setupUI() {
        [imageView, nameLabel, typesLabel, statsLabel, abilitiesLabel, evolutionsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        // Configuraciones visuales principales
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        
        typesLabel.numberOfLines = 0
        statsLabel.numberOfLines = 0
        abilitiesLabel.numberOfLines = 0
        evolutionsLabel.numberOfLines = 0
        
        typesLabel.textAlignment = .center
        statsLabel.textAlignment = .left
        abilitiesLabel.textAlignment = .center
        evolutionsLabel.textAlignment = .center
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        // Constraints
        NSLayoutConstraint.activate([
            // Imagen centrada horizontalmente, tamaño fijo y top safe area + 20
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            // Nombre abajo de la imagen con espacio
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Tipos abajo del nombre
            typesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            typesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            typesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Stats abajo de tipos
            statsLabel.topAnchor.constraint(equalTo: typesLabel.bottomAnchor, constant: 12),
            statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Habilidades abajo de stats
            abilitiesLabel.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 12),
            abilitiesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            abilitiesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Evoluciones abajo de habilidades
            evolutionsLabel.topAnchor.constraint(equalTo: abilitiesLabel.bottomAnchor, constant: 12),
            evolutionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            evolutionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            evolutionsLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func bind() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self, let detail = self.viewModel.pokemonDetail else { return }
            DispatchQueue.main.async {
                self.nameLabel.text = detail.name.capitalized
                self.imageView.loadImage(from: detail.imageUrl)
                self.typesLabel.text = "Types: \(detail.types.joined(separator: ", "))"
                self.statsLabel.text = "Stats:\n" + detail.stats.map { "\($0.name): \($0.value)" }.joined(separator: "\n")
                self.abilitiesLabel.text = "Abilities: \(detail.abilities.joined(separator: ", "))"
                self.evolutionsLabel.text = "Evolutions: \(detail.evolutions.joined(separator: " → "))"
            }
        }
    }
}

//
//  MainTabBarController.swift
//  PokeAppUIKit
//
//  Created by Macky on 31/05/25.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiService = PokemonAPIService()
        let repository = PokemonRepository(apiService: apiService)
        let fetchUseCase = FetchAllPokemonUseCase(repository: repository)
        let favoritesRepository = FavoritePokemonRepositoryRealm()
        let viewModelAll = PokemonListViewModel(
            fetchAllPokemonUseCase: fetchUseCase,
            favoriteRepository: favoritesRepository  // Ahora sí está declarado
        )
        let allVC = UINavigationController(rootViewController: PokemonListViewController(
            viewModel: viewModelAll,
            repository: repository,
            showFavorites: false)
        )
        allVC.tabBarItem = UITabBarItem(title: "Todos", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        let favoritesViewModel = FavoritesViewModel(repository: favoritesRepository)
        let favoritesVC = FavoritesViewController(viewModel: favoritesViewModel)
        
        let favNav = UINavigationController(rootViewController: favoritesVC)
        favNav.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "heart.fill"), tag: 1)
        
        viewControllers = [allVC, favNav]
    }

}

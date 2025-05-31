//
//  SceneDelegate.swift
//  PokeAppUIKit
//
//  Created by Macky on 27/05/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        // 📦 Dependencias compartidas
        let apiService = PokemonAPIService()
        let repository = PokemonRepository(apiService: apiService)
        let useCase = FetchAllPokemonUseCase(repository: repository)
        let favoritesRepository = FavoritePokemonRepositoryRealm()

        // 📱 Vista 1 - Lista de Pokémon
        let pokemonListVM = PokemonListViewModel(fetchAllPokemonUseCase: useCase)
        let pokemonListVC = PokemonListViewController(
            viewModel: pokemonListVM,
            repository: repository, showFavorites: false
        )
        pokemonListVC.tabBarItem = UITabBarItem(title: "Pokémon", image: UIImage(systemName: "list.bullet"), tag: 0)

        // ⭐️ Vista 2 - Favoritos
        let favoritesVM = FavoritesViewModel(repository: favoritesRepository)
        let favoritesVC = FavoritesViewController(viewModel: favoritesVM)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "heart.fill"), tag: 1)

        // 🧭 TabBarController
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: pokemonListVC),
            UINavigationController(rootViewController: favoritesVC)
        ]

        // 🪟 Set window
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}

//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene,
//               willConnectTo session: UISceneSession,
//               options connectionOptions: UIScene.ConnectionOptions) {
//
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        // Setup de dependencias
//        let apiService = PokemonAPIService()
//        let repository = PokemonRepository(apiService: apiService)
//        let useCase = FetchAllPokemonUseCase(repository: repository)
//        let viewModel = PokemonListViewModel(fetchAllPokemonUseCase: useCase)
//        let rootViewController = PokemonListViewController(viewModel: viewModel, repository: repository)
//
//        window.rootViewController = UINavigationController(rootViewController: rootViewController)
//        self.window = window
//        window.makeKeyAndVisible()
//    }
//}

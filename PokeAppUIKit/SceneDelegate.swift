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

        // Setup de dependencias
        let apiService = PokemonAPIService()
        let repository = PokemonRepository(apiService: apiService)
        let useCase = FetchAllPokemonUseCase(repository: repository)
        let viewModel = PokemonListViewModel(fetchAllPokemonUseCase: useCase)
        let rootViewController = PokemonListViewController(viewModel: viewModel, repository: repository)

        window.rootViewController = UINavigationController(rootViewController: rootViewController)
        self.window = window
        window.makeKeyAndVisible()
    }
}

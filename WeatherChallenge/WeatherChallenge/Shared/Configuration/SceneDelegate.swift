//
//  SceneDelegate.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        setRootViewController(scene: scene)
    }
    
    func createSearchScreen() -> UINavigationController {
        let logger = Logger()
        let networkHandler = NetworkHandler(apiHandler: APIHanndler(logger: logger), logger: logger, parser: Parser())
        let repository = SearchRepository(networkHandler: networkHandler)
        let viewModel = SearchViewModel(repository: repository)
        let controller = SearchViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: controller)
        return navigation
    }

    func setRootViewController(scene: UIWindowScene){
        window = UIWindow(windowScene: scene)
        window?.rootViewController = createSearchScreen()
        window?.makeKeyAndVisible()
    }

}

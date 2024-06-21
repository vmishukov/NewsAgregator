//
//  TabBarViewController.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 24.04.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    private let newsController = UINavigationController()
    private let favoriteNewsController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.viewControllers = [createNewsViewController(),createSelectedNewsViewController()]
    }
    
    private func createNewsViewController() -> UINavigationController {
        
        let networkClient = AsyncNetworkClientImpl()
        let dataStore = NewsDataStore()
        let newsService = NewsService(networkClient: networkClient, dataStore: dataStore)
        let dependencies = NewsAssembly.Dependencies(navigationController: newsController, newsService: newsService)
        let newsViewController = NewsAssembly.makeModule(dependencies: dependencies)
        newsViewController.tabBarItem = UITabBarItem(
            title: "Tab.News"~,
            image: .inlyNewsTab,
            tag: 1
        )
        newsController.viewControllers = [ newsViewController ]
        return newsController
    }
    
    private func createSelectedNewsViewController() -> UINavigationController {
        let dataStore = NewsDataStore()
        let favoriteNewsService = FavoriteNewsService(dataStore: dataStore)
        let dependencies = FavoriteNewsAssembly.Dependencies(navigationController: favoriteNewsController, newsService: favoriteNewsService)
        let favoriteNewsViewController = FavoriteNewsAssembly.makeModule(dependencies: dependencies)
        favoriteNewsViewController.tabBarItem = UITabBarItem(
            title: "Tab.SelectedNews"~,
            image: .inlySelectedNewsTab,
            tag: 2
        )
        favoriteNewsController.viewControllers = [favoriteNewsViewController]
        return favoriteNewsController
    }
    
    private func setupUI() {
        view.backgroundColor = .inlyWhite
    }
}

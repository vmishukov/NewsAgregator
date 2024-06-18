//
//  TabBarViewController.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 24.04.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    private let newsController = UINavigationController()
    private let selectedNewsController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.viewControllers = [createNewsViewController(),createSelectedNewsViewController()]
    }
    
    private func createNewsViewController() -> UINavigationController {
        
        let networkClient = AsyncNetworkClientImpl()
        let newsService = NewsService(networkClient: networkClient)
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
        let selectedNewsViewController = SelectedNewsViewController(presenter: SelectedNewsPresenter(selectedNewsService: SelectedNewsService(networkClient: AsyncNetworkClientImpl())))
        selectedNewsViewController.tabBarItem = UITabBarItem(
            title: "Tab.SelectedNews"~,
            image: .inlySelectedNewsTab,
            tag: 2
        )
        selectedNewsController.viewControllers = [selectedNewsViewController]
        return selectedNewsController
    }
    
    private func setupUI() {
        view.backgroundColor = .inlyWhite
    }
}

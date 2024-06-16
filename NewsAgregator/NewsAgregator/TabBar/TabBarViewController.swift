//
//  TabBarViewController.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 24.04.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.viewControllers = [createNewsViewController(),createSelectedNewsViewController()]
    }
    
    //MARK: - tabBar controllers
    private func createNewsViewController() -> UINavigationController {
        let newsViewController = NewsViewController(presenter: NewsPresenterImpls(newsService: NewsService(networkClient: AsyncNetworkClientImpl())))
        newsViewController.tabBarItem = UITabBarItem(
            title: "Tab.News"~,
            image: .inlyNewsTab,
            tag: 1
        )
        return UINavigationController(rootViewController: newsViewController)
    }
    
    private func createSelectedNewsViewController() -> UINavigationController {
        let selectedNewsViewController = SelectedNewsViewController(presenter: SelectedNewsPresenter(selectedNewsService: SelectedNewsService(networkClient: AsyncNetworkClientImpl())))
        selectedNewsViewController.tabBarItem = UITabBarItem(
            title: "Tab.SelectedNews"~,
            image: .inlySelectedNewsTab,
            tag: 2
        )
        return UINavigationController(rootViewController: selectedNewsViewController)
    }
    //MARK: - tab bar design
    private func setupUI() {
        view.backgroundColor = .inlyWhite
    }
}

//
//  FavoriteNewsAssembly.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 21.06.2024.
//

import Foundation
import UIKit

enum FavoriteNewsAssembly {
    
    struct Dependencies {
        let navigationController: UINavigationController
        let newsService: FavoriteNewsServiceProtocol
    }
    
    static func makeModule(dependencies: Dependencies) -> UIViewController {
        let interactor = FavoriteNewsInteractor(newsService: dependencies.newsService)
        let router = FavoriteNewsRouter(navigationController: dependencies.navigationController)
        let presenter = FavoriteNewsPresenter(interactor: interactor, router: router)
        let viewController = FavoriteNewsViewController(presenter: presenter)
        return viewController
    }
}

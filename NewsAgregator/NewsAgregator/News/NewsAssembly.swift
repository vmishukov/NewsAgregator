//
//  NewsAssembly.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 18.06.2024.
//

import Foundation
import UIKit

enum NewsAssembly {
    
    struct Dependencies {
        let navigationController: UINavigationController
        let newsService: NewsServiceProtocol
    }
    
    static func makeModule(dependencies: Dependencies) -> UIViewController {
        let interactor = NewsInteractor(newsService: dependencies.newsService)
        let router = NewsRouter(navigationController: dependencies.navigationController)
        let presenter = NewsPresenter(router: router, interactor: interactor)
        let viewController = NewsViewController(presenter: presenter)
        return viewController
    }
}

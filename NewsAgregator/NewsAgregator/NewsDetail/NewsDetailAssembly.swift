//
//  NewsDetailAssembly.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 21.06.2024.
//

import Foundation

import Foundation
import UIKit

enum NewsDetailAssembly {
    
    struct Dependencies {
        let newsService: NewsDetailServiceProtocol
    }
    
    struct Parameters {
        let newsDetailData: NewsDetailData
    }
    
    static func makeModule(dependencies: Dependencies, parameters: Parameters) -> UIViewController {

        let interactor = NewsDetailInteractor(newsService: dependencies.newsService)
        let presenter = NewsDetailPresenter(interactor: interactor)
        presenter.setDetailNews(set: parameters.newsDetailData)
        let viewController = NewsDetailViewController(presenter: presenter)
        return viewController
    }
}

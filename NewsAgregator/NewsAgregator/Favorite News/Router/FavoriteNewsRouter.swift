//
//  FavoriteNewsRouter.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 21.06.2024.
//

import Foundation

import Foundation
import UIKit

final class FavoriteNewsRouter {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showSelectedNewsScreen(with data: FavoriteNewsCollectionData) {
        let dependencies = NewsDetailAssembly.Dependencies(newsService: NewsDatailService(dataStore: NewsDataStore()))
        let data = NewsDetailData(articleId: data.articleId,
                                  title: data.title,
                                  link: data.link,
                                  sourceUrl: data.sourceUrl,
                                  description: data.description,
                                  content: data.content,
                                  pubDate: data.pubDate,
                                  imageUrl: data.imageUrl)
        let parameters = NewsDetailAssembly.Parameters(newsDetailData: data)
        let vc = NewsDetailAssembly.makeModule(dependencies: dependencies, parameters: parameters)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}
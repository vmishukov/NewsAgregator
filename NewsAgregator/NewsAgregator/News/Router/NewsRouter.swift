//
//  NewsRouter.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 17.06.2024.
//

import Foundation
import UIKit

final class NewsRouter {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showSelectedNewsScreen(with data: NewsCollectionData) {
        let vc = NewsDetailViewController(presenter: NewsDetailPresenter())
        vc.setDetailedNews(data)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}

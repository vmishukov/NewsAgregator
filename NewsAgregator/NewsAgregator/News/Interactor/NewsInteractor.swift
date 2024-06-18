//
//  NewsInteractor.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 17.06.2024.
//

import Foundation

protocol NewsInteractorProtocol {
    
    func fetchNextPage() async throws -> [NewsCollectionData]?
}

final class NewsInteractor: NewsInteractorProtocol {
    
    private var nextPageId = ""
    
    private let newsService: NewsServiceProtocol
    
    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
    }
    
    func fetchNextPage() async throws -> [NewsCollectionData]? {
        guard let result = try await newsService.fetchNextPage(nextPageId: nextPageId) else {
            return nil
        }
        
        if let nextPage = result.nextPage {
            nextPageId = nextPage
        }
        let newsData = result.results.map {
            NewsCollectionData(articleId: $0.articleId,
                               title: $0.title,
                               link: $0.link,
                               sourceUrl: $0.sourceUrl,
                               description: $0.description,
                               content: $0.content,
                               pubDate: $0.pubDate,
                               imageUrl: $0.imageUrl)
        }
        return newsData
    }
}

//
//  NewsInteractor.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 17.06.2024.
//

import Foundation

protocol NewsInteractorDelegate: AnyObject {
    
    func newsDataService(_: any NewsInteractorProtocol, like news: NewsCollectionData)
    
    func companiesDataServiceDislikeNews(_: any NewsInteractorProtocol, at newsId: String)
}

protocol NewsInteractorProtocol {
 
    var delegate: NewsInteractorDelegate? { get set }
    func fetchNextPage() async throws -> [NewsCollectionData]?
    func fetchLikedNews() throws -> [String]?
    func like(news: NewsCollectionData)
    func dislikeNews(with newsID: String)
}

final class NewsInteractor: NewsInteractorProtocol {

    

    weak var delegate: (any NewsInteractorDelegate)?
    
    private var nextPageId = ""
    
    private var newsService: NewsServiceProtocol
    
    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
        self.newsService.delegate = self
    }
    
    func fetchLikedNews() throws -> [String]? {
        return try newsService.fetchLikedNews()
    }
    
    func like(news: NewsCollectionData) {
        newsService.like(news: news)
    }
    
    func dislikeNews(with newsID: String) {
        newsService.dislikeNews(with: newsID)
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

extension NewsInteractor: NewsDataServiceDelegate {
    func newsDataService(_: any NewsServiceProtocol, like news: NewsCollectionData) {
        delegate?.newsDataService(self, like: news)
    }
    
    func companiesDataServiceDislikeNews(_: any NewsServiceProtocol, at newsId: String) {
        delegate?.companiesDataServiceDislikeNews(self, at: newsId)
    }
}

//
//  FavoriteNewsService.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 21.06.2024.
//

import Foundation

protocol FavoriteNewsDataServiceDelegate: AnyObject {
    
    func newsDataService(_: any FavoriteNewsServiceProtocol, like news: FavoriteNewsCollectionData, at indexPath: IndexPath)
    
    func companiesDataServiceDislikeNews(_: any FavoriteNewsServiceProtocol, at newsId: String)
}

protocol FavoriteNewsServiceProtocol {
    
    var delegate: FavoriteNewsDataServiceDelegate? { get set }
    func dislikeNews(with newsID: String)
    func fetchLikedNews() throws -> [FavoriteNewsCollectionData]?
}

final class FavoriteNewsService: FavoriteNewsServiceProtocol {
    
    weak var delegate: (any FavoriteNewsDataServiceDelegate)?
    var dataStore: NewsDataStoreProtocol
    
    init(dataStore: NewsDataStoreProtocol) {
        self.dataStore = dataStore
        self.dataStore.delegate = self
    }
    
    func dislikeNews(with newsID: String) {
        do {
            try dataStore.deleteNews(newsID)
        } catch {
            print(error)
        }
    }
    
    func fetchLikedNews() throws -> [FavoriteNewsCollectionData]? {
        guard let news = try dataStore.fetchNews() else { return nil }
        let collectionNews = news.map{
            FavoriteNewsCollectionData(articleId: $0.articleId ?? "",
                                       title: $0.title,
                                       link: $0.link,
                                       sourceUrl: $0.sourceUrl ?? "",
                                       description: $0.description,
                                       content: $0.content,
                                       pubDate: $0.pubDate,
                                       imageUrl: $0.imageUrl)
        }
        return collectionNews
    }
}


extension FavoriteNewsService: NewsDataStroreDelegate {
    
    func NewsDataStore(_: any NewsDataStoreProtocol, insert news: News, at indexPath: IndexPath) {
        let data = FavoriteNewsCollectionData(articleId: news.articleId ?? "",
                                      title: news.title,
                                      link: news.link,
                                      sourceUrl: news.sourceUrl ?? "",
                                      description: news.description,
                                      content: news.content,
                                      pubDate: news.pubDate,
                                      imageUrl: news.imageUrl)
        delegate?.newsDataService(self, like: data, at: indexPath)
    }
    
    func NewsDataStoreDeleteNews(_: any NewsDataStoreProtocol, at indexPath: IndexPath, with newsId: String) {
        delegate?.companiesDataServiceDislikeNews(self, at: newsId)
    }
}

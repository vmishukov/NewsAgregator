//
//  NewsService2.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 17.06.2024.
//

import Foundation

protocol NewsDataServiceDelegate: AnyObject {
    
    func newsDataService(_: any NewsServiceProtocol, like news: NewsCollectionData)
    
    func companiesDataServiceDislikeNews(_: any NewsServiceProtocol, at newsId: String)
}

protocol NewsServiceProtocol {
    var delegate: NewsDataServiceDelegate? { get set }
    func fetchNextPage(nextPageId: String) async throws -> NewsCollectionNetworkData?
    
    func like(news: NewsCollectionData)
    func dislikeNews(with newsID: String)
    func fetchLikedNews() throws -> [String]?
}

final class NewsService: NewsServiceProtocol {
    
    weak var delegate: NewsDataServiceDelegate?
    
    private let networkClient: AsyncNetworkClient
    private var dataStore: NewsDataStoreProtocol
    private var sortBy: String?
    
    
    init(networkClient: AsyncNetworkClient, dataStore: NewsDataStoreProtocol) {
        self.networkClient = networkClient
        self.dataStore = dataStore
        self.dataStore.delegate = self
    }
    
    func like(news: NewsCollectionData) {
        let newsCoreData = FavoriteNewsCoreData(articleId: news.articleId,
                                                title: news.title,
                                                link: news.link,
                                                sourceUrl: news.sourceUrl,
                                                description: news.description,
                                                content: news.content,
                                                pubDate: news.pubDate,
                                                imageUrl: news.imageUrl)
        do {
            try dataStore.addNews(newsCoreData)
        } catch {
            print(error)
        }
    }
    
    func dislikeNews(with newsID: String) {
        do {
            try dataStore.deleteNews(newsID)
        } catch {
            print(error)
        }
    }
    
    func fetchLikedNews() throws -> [String]? {
        guard let news = try dataStore.fetchNews() else { return nil }
        let collectionNews = news.map{
            $0.articleId ?? ""
        }
        return collectionNews
    }
    
    func fetchNextPage(nextPageId: String) async throws -> NewsCollectionNetworkData? {
        let request = buildGetRequest(nextPageId: nextPageId)
        
        let newItems = try await self.networkClient.fetch(from: request, as: NewsCollectionNetworkData.self)
        return newItems
    }
}

private extension NewsService {
    
    private func buildGetRequest(nextPageId: String) -> URLRequest {
        var queryItems = [URLQueryItem(name: "country", value: "ru")]
        if !nextPageId.isEmpty {
            queryItems.append(URLQueryItem(name: "page", value: nextPageId))
        }
        return urlRequest(
            method: .get,
            queryItems: queryItems)
    }
    
    func urlRequest(
        method: HttpMethod,
        queryItems: [URLQueryItem]?
    ) -> URLRequest {
        var components = URLComponents(string: RequestConstants.baseURL)!
        components.queryItems = queryItems
        var request = URLRequest(url: components.url!)
        request.setValue(RequestConstants.token, forHTTPHeaderField: RequestConstants.header)
        request.timeoutInterval = RequestConstants.timeoutInterval
        request.httpMethod = method.rawValue
        return request
    }
}

extension NewsService: NewsDataStroreDelegate {
    func NewsDataStore(_: any NewsDataStoreProtocol, insert news: News, at indexPath: IndexPath) {
        let data = NewsCollectionData(articleId: news.articleId ?? "",
                                      title: news.title,
                                      link: news.link,
                                      sourceUrl: news.sourceUrl ?? "",
                                      description: news.description,
                                      content: news.content,
                                      pubDate: news.pubDate,
                                      imageUrl: news.imageUrl)
        
        delegate?.newsDataService(self, like: data )
    }
    
    func NewsDataStoreDeleteNews(_: any NewsDataStoreProtocol, at indexPath: IndexPath, with newsId: String) {
        delegate?.companiesDataServiceDislikeNews(self, at: newsId)
    }
    
    
    
}

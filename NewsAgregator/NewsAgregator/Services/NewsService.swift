//
//  NewsService2.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 17.06.2024.
//

import Foundation

protocol NewsServiceProtocol {
    
    func fetchNextPage(nextPageId: String) async throws -> NewsCollectionNetworkData?
}

final class NewsService: NewsServiceProtocol {
    private let networkClient: AsyncNetworkClient
    private var sortBy: String?

    init(networkClient: AsyncNetworkClient) {
        self.networkClient = networkClient
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

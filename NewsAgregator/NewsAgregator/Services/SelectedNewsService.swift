//
//  SelectedNewsService.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 26.04.2024.
//

import Foundation

final class SelectedNewsService {
    private let networkClient: AsyncNetworkClient
    private var items: [NewsCollectionResultNetworkData] = []
    private let storage = SelectedNewsStorage.shared
    var itemsCount: Int { items.count }
    
    init(networkClient: AsyncNetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetch() async throws -> SelectedNewsServiceResult {
        guard let selectedNewsToFetch = sortSelectedNewsToAdd() else {
            return .empty
        }
        let request = buildGetRequest(selectedNews: selectedNewsToFetch)
        
        let newItems = try await self.networkClient.fetch(from: request, as: NewsCollectionNetworkData.self)
        return addNews(data: newItems)
    }
    
    private func addNews(data: NewsCollectionNetworkData) -> SelectedNewsServiceResult {
        let oldCount = itemsCount
        items.append(contentsOf: data.results)
        let newCount = itemsCount
     
        return .update(newIndexes: oldCount..<newCount)
    }
    
    private func sortSelectedNewsToAdd() -> String? {
        guard let selectedNews = storage.getSelectedNews() else { return nil }
        let array1 = Array(Set(selectedNews).subtracting(items.map{ $0.articleId }))
        return array1.isEmpty ? nil : array1.joined(separator: ",")
    }
    
    func item(at index: Int) -> NewsCollectionResultNetworkData {
        items[index]
    }
    
    func itemIndex(at newsId: String) -> Int? {
        items.map{ $0.articleId }.firstIndex(of: newsId)
    }
    
    func removeItem(at: Int) {
        items.remove(at: at)
    }
    
    func toRemove() -> [String]? {
        guard let selectedNews = storage.getSelectedNews() else { return nil }
        let array1 = Array(Set(items.map{ $0.articleId }).subtracting(selectedNews))
        return array1
    }
}

enum SelectedNewsServiceResult {
    case update(newIndexes: Range<Int>)
    case empty
}
// MARK: - make request
extension SelectedNewsService {
    private func buildGetRequest(selectedNews: String) -> URLRequest {
        let queryItems = [
            URLQueryItem(name: "id", value: selectedNews)
        ]
        return urlRequest(
            method: .get,
            queryItems: queryItems)
    }
    
    private func urlRequest(
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

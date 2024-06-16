//
//  NewsCollection.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 25.04.2024.
//

import Foundation

struct NewsCollection: Decodable {
    let status: String
    let totalResults: Int
    let results: [NewsCollectionResult]
    let nextPage: String?
}

struct NewsCollectionResult: Decodable {
    let articleId: String
    let title: String?
    let link: String?
    let sourceUrl: String
    let description: String?
    let content: String?
    let pubDate: String?
    let imageUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case articleId = "article_id"
        case title = "title"
        case link = "link"
        case sourceUrl = "source_url"
        case description = "description"
        case content = "content"
        case pubDate = "pubDate"
        case imageUrl = "image_url"
    }
}

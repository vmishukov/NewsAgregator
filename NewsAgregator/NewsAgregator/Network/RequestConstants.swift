//
//  RequestConstants.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 25.04.2024.
//

import Foundation

enum RequestConstants {
    static let baseURL = "https://newsdata.io/api/1/news"
    static let token = "pub_4268951fa49e29866ecf48db2b4dc4a03b972"
    static let header = "X-ACCESS-KEY"
    static let timeoutInterval = Double(60) // seconds
}

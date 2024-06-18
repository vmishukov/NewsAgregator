//
//  NetworkRequest.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 25.04.2024.
//

import Foundation

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
    var httpBody: String? { get }
    var secretInjector: (_ request: URLRequest) -> URLRequest { get }
}

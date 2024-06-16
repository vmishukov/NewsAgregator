//
//  NetworkTask.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 25.04.2024.
//

import Foundation

protocol NetworkTask {
    func cancel()
}

struct DefaultNetworkTask: NetworkTask {
    let dataTask: URLSessionDataTask

    func cancel() {
        dataTask.cancel()
    }
}

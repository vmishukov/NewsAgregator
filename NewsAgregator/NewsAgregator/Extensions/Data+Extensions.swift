//
//  Data+Extensions.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 25.04.2024.
//

import Foundation

class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}

private let decoder = JSONDecoder()
private let encoder = JSONEncoder()

extension Data {
    static func toJson<T: Encodable>(from dto: T) throws -> Data {
        try encoder.encode(dto)
    }

    func fromJson<T: Decodable>(to dtoType: T.Type) throws -> T {
        try decoder.decode(dtoType, from: self)
    }
}

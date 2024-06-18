//
//  Storage.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 26.04.2024.
//

import Foundation

enum StorageKey: String {
    case selectedNewsStorageKey = "selectedNews"
}

final class SelectedNewsStorage {
    static let shared = SelectedNewsStorage()
    private let userDefaults = UserDefaults.standard
    private init() {
        if storage == nil {
            userDefaults.set([], forKey: StorageKey.selectedNewsStorageKey.rawValue)
        }
    }
    
    private var storage: [String]? {
        get {
            userDefaults.array(forKey: StorageKey.selectedNewsStorageKey.rawValue) as? [String]
        }
        set {
            guard let newValue = newValue  else { return }
            userDefaults.set(newValue, forKey: StorageKey.selectedNewsStorageKey.rawValue)
        }
    }
    
    func getSelectedNews() -> [String]? {
        storage
    }
    
    func removeSelectedNewsById(newsId: String) {
        storage?.removeAll(where: {
            $0 == newsId
        })
    }
    
    func addSelectedNewsById(newsId: String) {
        storage?.append(newsId)
    }
}

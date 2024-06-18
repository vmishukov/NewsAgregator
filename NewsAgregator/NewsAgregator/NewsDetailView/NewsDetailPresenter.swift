//
//  NewsDetailPresenter.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 26.04.2024.
//

import Foundation

// MARK: - NewsDetailPresenterProtocol
protocol NewsDetailPresenterProtocol {
    var view: NewsDetailViewProtocol? { get set }
    var isSelected: Bool { get set }
    func setDetailNews(set: NewsCollectionData)
    func addSelectedNews()
    func deleteSelectedNews()
    func viewDidLoad()
}
// MARK: - NewsDetailPresenter
final class NewsDetailPresenter: NewsDetailPresenterProtocol {
    // MARK: - View
    weak var view: NewsDetailViewProtocol?
    // MARK: - public
    var isSelected: Bool = false
    // MARK: - private
    private let storage = SelectedNewsStorage.shared
    private var detailedNews: NewsCollectionData?
    // MARK: - public func
    func viewDidLoad() {
        guard let detailedNews = detailedNews else { return }
        isSelected = checkIfSelected(newsId: detailedNews.articleId)
        view?.setupDetailNews(detailedNews: detailedNews)
    }
    func setDetailNews(set: NewsCollectionData) {
        self.detailedNews = set
    }
    func addSelectedNews() {
        guard let newsId = detailedNews?.articleId else { return }
        storage.addSelectedNewsById(newsId: newsId)
    }
    func deleteSelectedNews() {
        guard let newsId = detailedNews?.articleId else { return }
        storage.removeSelectedNewsById(newsId: newsId)
    }
    // MARK: - private
    private  func checkIfSelected(newsId: String) -> Bool {
        guard let selectedNews = storage.getSelectedNews() else { return false }
        return selectedNews.contains(where: {
            $0 == newsId
        })
    }
}

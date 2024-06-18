//
//  NewsPresenter.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 25.04.2024.
//

import Foundation

protocol NewsPresenterProtocol {
    
    var numberOfRows: Int { get }
    func viewDidLoad(view: NewsViewProtocol)
    func rowData(at indexPath: IndexPath) -> NewsTableCellData?
    func likeNewsDidTapped(newsId: String)
    func dislikeNewsDidTapped(newsId: String)
    func checkIfSelected(newsId: String) -> Bool
    func didReachEndOfNews()
    func didSelectNewsAt(indexPath: IndexPath)
}

enum NewsTableViewState {
    case initial, loading, failed(Error), data(result: [NewsCollectionData]?)
}

final class NewsPresenter: NewsPresenterProtocol {
  
    weak var view: NewsViewProtocol?
    
    var numberOfRows: Int {
        newsList.count
    }
    
    private let interactor: NewsInteractorProtocol
    private let router: NewsRouter
    private var newsList = [NewsCollectionData]()
    
    private let storage = SelectedNewsStorage.shared
    private var state = NewsTableViewState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    init(router: NewsRouter, interactor: NewsInteractorProtocol) {
        
        self.router = router
        self.interactor = interactor
    }
    
    func rowData(at indexPath: IndexPath) -> NewsTableCellData? {
        guard indexPath.row < self.newsList.count-1 else { return nil }
        let data = newsList[indexPath.row]
        let cellData = NewsTableCellData(articleId: data.articleId,
                                         title: data.title,
                                         sourceUrl: data.sourceUrl,
                                         pubDate: data.pubDate,
                                         imageUrl: data.imageUrl)
        return cellData
    }
    
    func viewDidLoad(view: NewsViewProtocol) {
        self.view = view
        state = .loading
    }
    
    func didReachEndOfNews() {
        state = .loading
    }
    
    func likeNewsDidTapped(newsId: String) {
        storage.addSelectedNewsById(newsId: newsId)
    }
    
    func dislikeNewsDidTapped(newsId: String) {
        storage.removeSelectedNewsById(newsId: newsId)
    }
    
    func checkIfSelected(newsId: String) -> Bool {
        guard let selectedNews = storage.getSelectedNews() else { return false }
        return selectedNews.contains(where: {
            $0 == newsId
        })
    }
    
    func didSelectNewsAt(indexPath: IndexPath) {
        guard indexPath.row < self.newsList.count-1 else { return }
        let data = newsList[indexPath.row]
        router.showSelectedNewsScreen(with: data)
    }
}

private extension NewsPresenter {
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            loadCollections()
        case .data(let result):
            guard let result = result else { return }
            view?.update(newIndexes: addNew(data: result))
        case .failed(let error):
            print(error.localizedDescription)
        }
    }
    
    private func loadCollections() {
        Task {
            do {
                let result = try await interactor.fetchNextPage()
                await MainActor.run {
                    self.state = .data(result: result)
                }
            } catch {
                await MainActor.run {
                    self.state = .failed(error)
                }
            }
        }
    }
    
    private func addNew(data: [NewsCollectionData]) -> Range<Int> {
        let oldCount = newsList.count

        newsList.append(contentsOf: data)
        let newCount = newsList.count
        
        return oldCount..<newCount
    }
}

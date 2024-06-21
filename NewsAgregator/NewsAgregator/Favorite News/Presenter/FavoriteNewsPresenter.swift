//
//  SelectedNewsPresenter.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 26.04.2024.
//

import Foundation

protocol FavoriteNewsPresenterProtocol {
    
    var numberOfRows: Int { get }
    func viewDidLoad(view: SelectedNewsViewProtocol)
    func rowData(at indexPath: IndexPath) -> NewsTableCellData?
    func updateSelectedNews(newsId: String)
    func didSelectNewsAt(indexPath: IndexPath)
}

final class FavoriteNewsPresenter: FavoriteNewsPresenterProtocol {
    
    private weak var view: SelectedNewsViewProtocol?
    
    var numberOfRows: Int {
        likedNews.count
    }
    
    private var likedNews = [FavoriteNewsCollectionData]()
    private var interactor: FavoriteNewsInteractorProtocol
    private let router: FavoriteNewsRouter
    
    init(interactor: FavoriteNewsInteractorProtocol, router: FavoriteNewsRouter) {
        self.router = router
        self.interactor = interactor
        self.interactor.delegate = self
        loadCollections()
    }
    
    func viewDidLoad(view: SelectedNewsViewProtocol) {
        self.view = view
        loadCollections()
    }
    
    func rowData(at indexPath: IndexPath) -> NewsTableCellData? {
        guard indexPath.row < self.likedNews.count else { return nil }
        let data = likedNews[indexPath.row]
        let cellData = NewsTableCellData(articleId: data.articleId,
                                         title: data.title,
                                         sourceUrl: data.sourceUrl,
                                         pubDate: data.pubDate,
                                         imageUrl: data.imageUrl)
        return cellData
    }
    
    func updateSelectedNews(newsId: String) {
        deleteSelectedNews(newsId: newsId)
       
    }
    
    func didSelectNewsAt(indexPath: IndexPath) {
        guard indexPath.row < self.likedNews.count-1 else { return }
        let data = likedNews[indexPath.row]
        router.showSelectedNewsScreen(with: data)
    }
}

private extension FavoriteNewsPresenter {
    
    func deleteSelectedNews(newsId: String) {
        interactor.dislikeNews(with: newsId)
    }
    
    func loadCollections() {
        Task {
            do {
                guard let result = try interactor.fetchLikedNews() else { return }
                await MainActor.run {
                    self.likedNews = result
                    view?.updateTable()
                }
            } catch {
                await MainActor.run {
                   print(error)
                }
            }
        }
    }
}

extension FavoriteNewsPresenter: FavoriteNewsInteractorDelegate {
    
    func newsDataService(_: any FavoriteNewsInteractorProtocol, like news: FavoriteNewsCollectionData, at indexPath: IndexPath) {
        if let view = self.view {
            likedNews.insert(news, at: indexPath.row)
            view.updateTable()
        }
    }
    
    func companiesDataServiceDislikeNews(_: any FavoriteNewsInteractorProtocol, at newsId: String) {
        guard let index = likedNews.map({ $0.articleId }).firstIndex(of: newsId) else { return }
        likedNews.remove(at: index)
        view?.removeAt(at: [IndexPath(row: index, section: 0)])
    }
}

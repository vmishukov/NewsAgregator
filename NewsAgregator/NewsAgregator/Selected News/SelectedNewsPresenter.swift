//
//  SelectedNewsPresenter.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 26.04.2024.
//

import Foundation

enum SelectedNewsTableViewState {
    case initial, loading, failed(Error), data(result: SelectedNewsServiceResult)
}

protocol SelectedNewsPresenterProtocol {
    var view: SelectedNewsViewProtocol? { get set }
    var numberOfRows: Int { get }
    func viewDidAppear()
    func rowData(at indexPath: IndexPath) -> NewsCollectionResult?
    func updateSelectedNews(newsId: String)
}

final class SelectedNewsPresenter: SelectedNewsPresenterProtocol {
    //MARK: - view
    weak var view: SelectedNewsViewProtocol?
    //MARK: - public
    var numberOfRows: Int {
        selectedNewsService.itemsCount
    }
    //MARK: - private
    private var selectedNewsService: SelectedNewsService
    private let storage = SelectedNewsStorage.shared
    private var state = SelectedNewsTableViewState.initial {
        didSet {
            stateDidChanged()
        }
    }
    //MARK: - init
    init(selectedNewsService: SelectedNewsService) {
        self.selectedNewsService = selectedNewsService
    }
    //MARK: - public func
    func viewDidAppear() {
        check()
        state = .loading
    }
    
    func rowData(at indexPath: IndexPath) -> NewsCollectionResult? {
        selectedNewsService.item(at: indexPath.row)
    }
    
    func updateSelectedNews(newsId: String) {
        deleteSelectedNews(newsId: newsId)
        storage.removeSelectedNewsById(newsId: newsId)
    }
    //MARK: - Private func
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            loadCollections()
        case .data(let result):
            switch result {
            case .update(newIndexes: let newIndexes):
                view?.update(newIndexes: newIndexes)
            case .empty:
                break
            }
        case .failed(let error):
            print(error.localizedDescription)
        }
    }
    
    private func check() {
        let toRemove = selectedNewsService.toRemove()
        guard let toRemove = toRemove else { return }
        toRemove.forEach{ item in
            deleteSelectedNews(newsId: item)
        }
    }
    
    private func deleteSelectedNews(newsId: String) {
        guard let index = selectedNewsService.itemIndex(at: newsId) else { return }
        selectedNewsService.removeItem(at: index)
        view?.removeAt(at: [IndexPath(row: index, section: 0)])
    }
    
    private func loadCollections() {
        Task {
            do {
                let result = try await selectedNewsService.fetch()
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
}

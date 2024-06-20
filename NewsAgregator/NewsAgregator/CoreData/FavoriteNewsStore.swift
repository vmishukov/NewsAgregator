//
//  FavoriteNewsStore.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 20.06.2024.
//

import Foundation
import CoreData
import UIKit

protocol NewsDataStroreDelegate: AnyObject {
    
    func NewsDataStore(_ : any NewsDataStoreProtocol, insert news: News, at indexPath: IndexPath)
    
    func NewsDataStoreDeleteNews(_ : any NewsDataStoreProtocol, at indexPath: IndexPath, with newsId: String)
}

protocol NewsDataStoreProtocol {
    
    var delegate: NewsDataStroreDelegate? { get set }
    func addNews(_ favoriteNews: FavoriteNewsCoreData) throws
    func deleteNews(_ articleId: String) throws
    func fetchNews() throws -> [News]?
}

final class NewsDataStore: NSObject, NewsDataStoreProtocol {
    
    weak var delegate: NewsDataStroreDelegate?
    
    private let context: NSManagedObjectContext
    private var NewsFetchResultController: NSFetchedResultsController<News>?
    
    
    override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.context = context
        super.init()
        self.setupFetchResultController()
    }
    
    func fetchNews() throws -> [News]? {
        let fetchRequest = News.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "articleId", ascending: true)]
        let NewsFromCoreData = try context.fetch(fetchRequest)
        return NewsFromCoreData
    }
    
    func addNews(_ favoriteNews: FavoriteNewsCoreData) throws {
        let fetchRequest = News.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             #keyPath(News.articleId),
                                             favoriteNews.articleId)
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                let news = News(context: context)
                news.articleId = favoriteNews.articleId
                news.content = favoriteNews.content
                news.imageUrl = favoriteNews.imageUrl
                news.link = favoriteNews.link
                news.newsDescription = favoriteNews.description
                news.pubDate = favoriteNews.pubDate
                news.sourceUrl = favoriteNews.sourceUrl
                news.title = favoriteNews.title
                try context.save()
                return
            }
            return
        } catch {
            throw error
        }
    }
    
    func deleteNews(_ articleId: String) throws {
        let fetchRequest = News.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             #keyPath(News.articleId),
                                             articleId)
        let News = try context.fetch(fetchRequest)
        News.forEach { context.delete($0) }
        try context.save()
    }
}

private extension NewsDataStore {
    
    private func setupFetchResultController() {
        let fetchRequest = News.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "articleId", ascending: true)]
        let context = self.context
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        self.NewsFetchResultController = fetchedResultController
    }
}

extension NewsDataStore: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            if let indexPath = newIndexPath, let news = anObject as? News {
                delegate?.NewsDataStore(self, insert: news, at: indexPath)
            }
            break
            
        case .delete:
            if let indexPath = indexPath, let news = anObject as? News {
                delegate?.NewsDataStoreDeleteNews(self, at: indexPath, with: news.articleId ?? "")
            }
            break
            
        default:
            break
        }
    }
}


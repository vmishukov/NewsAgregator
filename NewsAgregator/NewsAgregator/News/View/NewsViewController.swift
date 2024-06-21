//
//  NewsViewController.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 24.04.2024.
//

import UIKit

protocol NewsViewProtocol: AnyObject {
    
    func update(newIndexes: Range<Int>)
    func updateTable()
}

final class NewsViewController: UIViewController {
    
    private let presenter: NewsPresenterProtocol
    private let contentView = NewsView()
    
    init(presenter: NewsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(view: self)
        setupContentView()
        setupNavBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

private extension NewsViewController {
    
    func setupNavBar() {
        navigationItem.title = "News.Title"~
    }
    
    func setupContentView() {
        contentView.newsTableView.delegate = self
        contentView.newsTableView.dataSource = self
    }
}
extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectNewsAt(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == presenter.numberOfRows {
            presenter.didReachEndOfNews()
        }
    }
}

extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableCell.identifier,
            for: indexPath
        ) as? NewsTableCell
        else {
            return UITableViewCell()
        }
        guard
            let rowData = presenter.rowData(at: indexPath)
        else { return UITableViewCell() }
        cell.initData(rowData: rowData, isSelected: presenter.checkIfSelected(newsId: rowData.articleId))
        cell.delegate = self
        return cell
    }
}

extension NewsViewController: NewsViewProtocol {
    
    func updateTable() {
        contentView.newsTableView.reloadData()
    }
    
    func update(newIndexes: Range<Int>) {
        if newIndexes.isEmpty { return }
        contentView.newsTableView.performBatchUpdates {
            let indexPaths = newIndexes.map { index in
                IndexPath(row: index, section: 0)
            }
            contentView.newsTableView.insertRows(at: indexPaths, with: .bottom)
        } completion: { _ in
        }
    }
}

extension NewsViewController: NewsTableCellDelegate {
    
    func likeNewsDidTappedWith(newsId: String) {
        presenter.likeNewsDidTapped(newsId: newsId)
    }
    
    func dislikeNewsDidTappedWith(newsId: String) {
        presenter.dislikeNewsDidTapped(newsId: newsId)
    }
}

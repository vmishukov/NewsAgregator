//
//  SelectedNewsViewController.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 24.04.2024.
//

import Foundation
import UIKit

protocol SelectedNewsViewProtocol: AnyObject {
    func update(newIndexes: Range<Int>)
    func removeAt(at: [IndexPath])
}

final class SelectedNewsViewController: UIViewController {
    //MARK: - PRESENTER
    private var presenter: SelectedNewsPresenterProtocol
    //MARK: - UI
    private lazy var selectedNewsTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
       // tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableCell.self, forCellReuseIdentifier: NewsTableCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        return tableView
    }()
    //MARK: - INIT
    init(presenter: SelectedNewsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
        presenter.view = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    //MARK: - setup navbar
    private func setupNavBar() {
        navigationItem.title = "SelectedNews.Title"~
    }
    //MARK: - setup constraits
    private func setupUI() {
        NSLayoutConstraint.activate([
            selectedNewsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectedNewsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            selectedNewsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            selectedNewsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
//MARK: - UITableViewDelegate
/*
extension SelectedNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        guard
            let rowData = presenter.rowData(at: indexPath)
        else { return }
        let vc = NewsDetailViewController(presenter: NewsDetailPresenter())
        let data =  NewsCollectionData(articleId: rowData.articleId,
                                       title: rowData.title,
                                       link: rowData.link,
                                       sourceUrl: rowData.sourceUrl,
                                       description: rowData.description,
                                       content: rowData.content,
                                       pubDate: rowData.pubDate,
                                       imageUrl: rowData.imageUrl)
        vc.setDetailedNews(data)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
 */
//MARK: - UITableViewDataSource
extension SelectedNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
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
        
        let data = NewsTableCellData(articleId: rowData.articleId,
                                     title: rowData.title,
                                     sourceUrl: rowData.sourceUrl,
                                     pubDate: rowData.pubDate,
                                     imageUrl: rowData.imageUrl)
        cell.initData(rowData: data, isSelected: true)
        cell.delegate = self
        return cell
    }
}
//MARK: - SelectedNewsViewProtocol
extension SelectedNewsViewController: SelectedNewsViewProtocol {
    
    func removeAt(at: [IndexPath]) {
        selectedNewsTableView.deleteRows(at: at, with: .fade)
    }
    
    func update(newIndexes: Range<Int>) {
        if newIndexes.isEmpty { return }
        selectedNewsTableView.performBatchUpdates {
            let indexPaths = newIndexes.map { index in
                IndexPath(row: index, section: 0)
            }
            selectedNewsTableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in
        }
    }
}

//MARK: - NewsTableCellDelegate
extension SelectedNewsViewController: NewsTableCellDelegate {
    func likeNewsDidTappedWith(newsId: String) {
        assertionFailure("Cannot be clicked here")
    }
    
    func dislikeNewsDidTappedWith(newsId: String) {
        presenter.updateSelectedNews(newsId: newsId)
    }
}

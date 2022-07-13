//
//  NewsListViewController.swift
//  NewsApp
//
//  Created by User on 08.06.2022.
//

import Foundation
import UIKit

protocol NewsListDisplayLogicProtocol: AnyObject {
    func displayNewsList(viewModel: NewsList.ShowNews.ViewModel)
}

class NewsListViewController: UIViewController {

    var interactor: NewsListBusinessLogicProtocol?
    var router: (NSObjectProtocol & NewsListRoutingLogicProtocol & NewsListDataPassingProtocol)?

    let tableView = UITableView()
    let refreshControl = UIRefreshControl()

    private var rows: [NewsListCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.setFormatedDatePublished()
        tableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: String(localized: "searching_news"))
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        passRequest()
        tableView.dataSource = self
        tableView.delegate = self
        setupNavigationBar()
        setupTableView()
        setupConstraint()
        

    }

    private func passRequest() {
        interactor?.provideNewsList()
    }
    
    @objc private func didPullToRefresh() {
        interactor?.reFetchNews(queryType: .sources)
        
        if self.refreshControl.isRefreshing == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - DisplayLogicProtocol
extension NewsListViewController: NewsListDisplayLogicProtocol {
    func displayNewsList(viewModel: NewsList.ShowNews.ViewModel) {
        
        rows = viewModel.rows
        

    }
}

// MARK: - Setup NavigationBar
extension NewsListViewController {

    private func setupNavigationBar() {
        navigationItem.title = "\(rows.first?.source ?? "")"
        navigationController?.navigationBar.backgroundColor = .systemBackground
    }
}

// MARK: - Setup TableView

extension NewsListViewController {

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(NewsListCell.self, forCellReuseIdentifier: "NewsListCell")
    }

    private func setupConstraint() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellViewModel = rows[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.identifier, for: indexPath) as? NewsListCell else { return UITableViewCell()}
        cell.viewModel = cellViewModel
        cell.configure(unbrandering: rows[indexPath.row].unbrandening)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rows[indexPath.row].unbrandening = false
        rows[indexPath.row].unread = false
        interactor?.provideUrlSelectedNewsForWeb(selected: rows[indexPath.row].url)
        interactor?.provideUrlReadNews(news: rows)
        router?.routeToNewsDetails()

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        rows[indexPath.row].height
    }
}

//
//  NewsSearchViewController.swift
//  NewsApp
//
//  Created by User on 23.06.2022.
//

import Foundation
import UIKit

protocol NewsSearchDisplayLogicProtocol: AnyObject {
    func displayNewsSearch(viewModel: NewsSearch.ShowNews.ViewModel)
}

class NewsSearchViewController: UIViewController {

    var interactor: NewsSearchBusinessLogicProtocol?
    var router: (NSObjectProtocol & NewsSearchRoutingLogicProtocol & NewsSearchDataPassingProtocol)?
    

    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)

    private var rows: [NewsSearchCellViewModel] = [] 

    override func viewDidLoad() {
        super.viewDidLoad()
        NewsSearchConfigurator.shared.build(viewController: self)
        tableView.dataSource = self
        tableView.delegate = self
        
        setupNavigationBar()
        setupTableView()
        setupConstraintTableView()
        searchController.searchBar.delegate = self
        
        tableView.backgroundView = nil

    }

    private func passRequest(query: String) {
        interactor?.searchNews(queryType: .q, query: query)
    }
    
    private func searchResultIsEmpty() -> Bool {
        let status = interactor?.checkIfIsNews()
        return status ?? true
    }
    
    private func setPlugForScreen() {
        let label = UILabel()
        label.text = String(localized: "result_search_NewsSearch")
        label.font = .systemFont(ofSize: 50, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        tableView.backgroundView = label
        
    }
    
 }

 // MARK: - DisplayLogicProtocol
extension NewsSearchViewController: NewsSearchDisplayLogicProtocol {
    func displayNewsSearch(viewModel: NewsSearch.ShowNews.ViewModel) {
         rows = viewModel.rows
        if rows.isEmpty {
            setPlugForScreen()
        }
        tableView.reloadData()
     }
 }
 
 // MARK: - Setup TableView
 extension NewsSearchViewController {

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
    }

    private func setupConstraintTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
 }

// MARK: - Setup NavigationBar
extension NewsSearchViewController {
    
    private func setupNavigationBar() {
        self.navigationItem.title = String(localized: "title_NewsSearch")
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = String(localized: "search_query")
        navigationController?.navigationBar.backgroundColor = .systemBackground
    }
}

// MARK: - Setup SearchBarDelegate
extension NewsSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            passRequest(query: text)
            tableView.backgroundView = nil
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.backgroundView = nil
        searchBar.text = ""
        rows = []
        tableView.reloadData()
    }
}


//  MARK: - UITableViewDataSource, UITableViewDelegate
 extension NewsSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellViewModel = rows[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.identifier, for: indexPath) as? SearchCell else { return UITableViewCell()}
        cell.viewModel = cellViewModel
        cell.configure(unbrandering: rows[indexPath.row].unbrandening)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rows[indexPath.row].unbrandening = false
        rows[indexPath.row].unread = false
        interactor?.provideUrlSelectedNewsForWeb(selected: rows[indexPath.row].url)
        interactor?.updateFoundNews(url: rows[indexPath.row].url)
        interactor?.getUrlForReadNews()
        router?.routeToNewsDetails()
        tableView.reloadData()
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rows[indexPath.row].height
    }
 }

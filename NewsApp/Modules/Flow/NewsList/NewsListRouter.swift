//
//  NewsListRouter.swift
//  NewsApp
//
//  Created by User on 08.06.2022.
//

import Foundation

@objc protocol NewsListRoutingLogicProtocol {
    func routeToNewsDetails()
}

protocol NewsListDataPassingProtocol {
    var dataStore: NewsListDataStoreProtocol? { get }
}

class NewsListRouter: NSObject, NewsListRoutingLogicProtocol, NewsListDataPassingProtocol {

    weak var viewController: NewsListViewController?
    var dataStore: NewsListDataStoreProtocol?

    func routeToNewsDetails() {
        let detailsVC = NewsDetailsViewController()
        detailsVC.url = dataStore?.urlForNewsDetails
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

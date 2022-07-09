//
//  NewsSearchRouter.swift
//  NewsApp
//
//  Created by User on 01.07.2022.
//

import Foundation

@objc protocol NewsSearchRoutingLogicProtocol {
    func routeToNewsDetails()
}

protocol NewsSearchDataPassingProtocol {
    var dataStore: NewsSearchDataStoreProtocol? { get }
}

class NewsSearchRouter: NSObject, NewsSearchRoutingLogicProtocol, NewsSearchDataPassingProtocol {

    weak var viewController: NewsSearchViewController?
    var dataStore: NewsSearchDataStoreProtocol?

    func routeToNewsDetails() {
        let detailsVC = NewsDetailsViewController()
        detailsVC.url = dataStore?.urlForNewsDetails
        
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }

}

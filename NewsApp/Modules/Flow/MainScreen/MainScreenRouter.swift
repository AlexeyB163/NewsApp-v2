//
//  NewsListRouter.swift
//  NewsApp
//
//  Created by User on 03.06.2022.
//

import Foundation
import UIKit

@objc protocol MainScreenRoutingLogicProtocol {
    func routeToChannelsList()
    func routeToNewsList()
}
protocol MainScreenDataPassingProtocol {
    var dataStore: MainScreenDataStoreProtocol? { get }
}

class MainScreenRouter: NSObject, MainScreenRoutingLogicProtocol, MainScreenDataPassingProtocol {

    weak var viewController: MainScreenViewController?
    var dataStore: MainScreenDataStoreProtocol?
    var updateNews: [News] = []
    // MARK: Routing

    func routeToChannelsList() {
        let news = dataStore?.news ?? []

        let channelsVC = ChannelListConfigurator.build(news: news) { news in
            self.dataStore?.updatedNews = news ?? []
            self.updateNews = news ?? []

        }
        let vc = UINavigationController(rootViewController: channelsVC)
        viewController?.present(vc, animated: true, completion: nil)

    }

    func routeToNewsList() {

        if updateNews.isEmpty {
            let store = dataStore?.newsForNewsList
            let newsListVC = NewsListConfigurator.shared.build(with: store ?? []) { news  in
                self.dataStore?.updatedNewsFromNewsList = news ?? []
                self.dataStore?.newsForSelectedChannels = news ?? []
                self.dataStore?.newsRead = news  ?? []

            }

            viewController?.navigationController?.pushViewController(newsListVC, animated: true)
        } else {
            let store = dataStore?.updateNewsForNewsList
            let newsListVC = NewsListConfigurator.shared.build(with: store ?? []) { news in
                self.dataStore?.newsRead = news ?? []

            }

            viewController?.navigationController?.pushViewController(newsListVC, animated: true)
        }

    }

}

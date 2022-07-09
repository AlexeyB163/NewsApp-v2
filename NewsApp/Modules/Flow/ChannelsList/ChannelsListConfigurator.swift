//
//  ChannelsListConfigurator.swift
//  NewsApp
//
//  Created by User on 20.06.2022.
//

import Foundation
import UIKit

final class ChannelListConfigurator {
    static func build(news: [News], completion: @escaping (([News]?) -> Void) ) -> UIViewController {
        let viewController = ChannelsListViewController()
        let interactor = ChannelsListInteractor()
        let presenter = ChannelsListPresenter()
        let worker = ChannelsWorker()
        viewController.interactor = interactor
        interactor.worker = worker
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        interactor.news = news
        interactor.completion = completion
        
        viewController.tableView.reloadData()
        

//let router = ChannelsListRouter()
//        viewController.router = router
//        router.viewController = viewController
//        router.dataStore = interactor

        return viewController
    }
}

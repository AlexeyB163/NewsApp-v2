//
//  NewsListConfigurator.swift
//  NewsApp
//
//  Created by User on 21.06.2022.
//

import Foundation
import UIKit

final class NewsListConfigurator {

    static let shared = NewsListConfigurator()

    private init() {}

    func build(with news: [News], completion: @escaping (([News]?) -> Void)) -> UIViewController {
        let viewController = NewsListViewController()
        let interactor = NewsListInteractor()
        interactor.news = news
        interactor.tmpNews = news
        interactor.completion = completion

        let presenter = NewsListPresenter()
        let router = NewsListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        return viewController
    }
}

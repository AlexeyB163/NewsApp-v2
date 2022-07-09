//
//  NewsListPresenter.swift
//  NewsApp
//
//  Created by User on 03.06.2022.
//

import Foundation

protocol MainScreenPresentationLogicProtocol {
    func presentNews(response: MainNewsList.ShowNews.Response)
    func presentUpdateNews(response: MainNewsList.ShowNews.Response)
}

class MainScreenPresenter: MainScreenPresentationLogicProtocol {

    weak var viewController: MainScreenDisplayLogicProtocol?

    func presentNews(response: MainNewsList.ShowNews.Response) {

        let items = response.news.map { MainNewsCellViewModel(news: $0, countUnreadNews: response.countUnreadNews) }
        let viewModel = MainNewsList.ShowNews.ViewModel(items: items)

        viewController?.displayMainNews(viewModel: viewModel)
    }

    func presentUpdateNews(response: MainNewsList.ShowNews.Response) {
        let items = response.news.map { MainNewsCellViewModel(news: $0, countUnreadNews: response.countUnreadNews) }
        let viewModel = MainNewsList.ShowNews.ViewModel(items: items)

        viewController?.updateNews(viewModel: viewModel)
    }
}

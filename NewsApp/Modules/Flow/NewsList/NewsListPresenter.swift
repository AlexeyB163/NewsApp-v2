//
//  NewsListPresenter.swift
//  NewsApp
//
//  Created by User on 08.06.2022.
//

import Foundation

protocol NewsListPresentationLogicProtocol {
    func presentNewsList(response: NewsList.ShowNews.Response)
}

class NewsListPresenter: NewsListPresentationLogicProtocol {

    weak var viewController: NewsListViewController?

    func presentNewsList(response: NewsList.ShowNews.Response) {
        let rows = response.news.map {NewsListCellViewModel(news: $0)}
        let viewModel = NewsList.ShowNews.ViewModel(rows: rows)
        viewController?.displayNewsList(viewModel: viewModel)
    }
}

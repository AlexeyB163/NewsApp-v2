//
//  NewsSearchPresenter.swift
//  NewsApp
//
//  Created by User on 23.06.2022.
//

import Foundation

protocol NewsSearchPresentationLogicProtocol {
    func presentNewsSearch(response: NewsSearch.ShowNews.Response)
}

class NewsSearchPresenter: NewsSearchPresentationLogicProtocol {

    weak var viewController: NewsSearchViewController?

    func presentNewsSearch(response: NewsSearch.ShowNews.Response) {
        let rows = response.news.map {NewsSearchCellViewModel(news: $0)}
        
        let viewModel = NewsSearch.ShowNews.ViewModel(rows: rows)
        viewController?.displayNewsSearch(viewModel: viewModel)

    }

}

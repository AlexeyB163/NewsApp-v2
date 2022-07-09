//
//  NewsSearchModels.swift
//  NewsApp
//
//  Created by User on 23.06.2022.
//

import Foundation

protocol CellNewsSearchIdentifiableProtocol {
    var identifier: String { get }
    var height: Double { get }
}

enum NewsSearch {

    // MARK: Use cases
    enum ShowNews {
        struct Response {
            let news: [News]
        }

        // массив моделей описывающих ячейки
        struct ViewModel {
            struct NewsSearchCellViewModel: CellNewsSearchIdentifiableProtocol {
                var identifier: String {
                    "SearchCell"
                }
                var height: Double {
                    100
                }

                let title: String
                let source: String
                let publishedAt: String
                let imageURL: String
                let description: String
                let url: String
                var unbrandening: Bool
                var unread: Bool

                init(news: News) {
                    title = news.title ?? ""
                    source = news.source.name
                    publishedAt = news.publishedAt ?? ""
                    imageURL = news.urlToImage ?? ""
                    description = news.description ?? ""
                    url = news.url ?? ""
                    unbrandening = news.unbrandening ?? true
                    unread = news.unread ?? true
                }
            }
            let rows: [NewsSearchCellViewModel]
        }
    }
}

typealias NewsSearchCellViewModel = NewsSearch.ShowNews.ViewModel.NewsSearchCellViewModel

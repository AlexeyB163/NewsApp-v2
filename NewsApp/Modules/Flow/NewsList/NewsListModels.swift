//
//  NewsListModels.swift
//  NewsApp
//
//  Created by User on 08.06.2022.
//

import Foundation

protocol CellNewsListIdentifiableProtocol {
    var identifier: String { get }
    var height: Double { get }
}

enum NewsList {

    // MARK: Use cases
    enum ShowNews {
        struct Response {
            let news: [News]
        }

        struct ViewModel {
            struct NewsListCellViewModel: CellNewsListIdentifiableProtocol {
                var identifier: String {
                    "NewsListCell"
                }
                var height: Double {
                    100
                }

                let title: String
                let source: String
                let id: String
                let publishedAt: String
                let imageURL: String
                let description: String
                let url: String
                var unbrandening: Bool
                var unread: Bool

                init(news: News) {
                    title = news.title ?? ""
                    source = news.source.name
                    id = news.source.id ?? ""
                    publishedAt = news.publishedAt ?? ""
                    imageURL = news.urlToImage ?? ""
                    description = news.description ?? ""
                    url = news.url ?? ""
                    unbrandening = news.unbrandening ?? true
                    unread = news.unread ?? true
                }
            }
            let rows: [NewsListCellViewModel]
        }
    }
}

typealias NewsListCellViewModel = NewsList.ShowNews.ViewModel.NewsListCellViewModel

//
//  NewsListModels.swift
//  NewsApp
//
//  Created by User on 03.06.2022.
//

import Foundation

protocol CellMainScreenIdentifiableProtocol {
    var identifier: String { get }
}

enum MainNewsList {

    // MARK: Use cases
    enum ShowNews {
        struct Response {
            let news: [News]
            let countUnreadNews: [String: Int]
        }

        struct ViewModel {
            struct NewsCellViewModel: CellMainScreenIdentifiableProtocol {
                var identifier: String {
                    "MainNewsCell"
                }

                let title: String
                let source: String
                let id: String
                let imageURL: String
                let description: String
                var unbrandening: Bool
                var unread: Bool
                let countUnreadNews: [String: Int]

                init(news: News, countUnreadNews: [String: Int]) {
                    title = news.title ?? ""
                    source = news.source.name
                    id = news.source.id ?? ""
                    imageURL = news.urlToImage ?? ""
                    description = news.description ?? ""
                    unbrandening = news.unbrandening ?? true
                    unread = news.unread ?? true
                    self.countUnreadNews = countUnreadNews
                }

            }
            let items: [NewsCellViewModel]
        }
    }
}

typealias MainNewsCellViewModel = MainNewsList.ShowNews.ViewModel.NewsCellViewModel

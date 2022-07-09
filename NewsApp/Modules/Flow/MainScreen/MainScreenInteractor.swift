//
//  NewsListInteractor.swift
//  NewsApp
//
//  Created by User on 03.06.2022.
//

import Foundation

protocol MainScreenBusinessLogicProtocol {
    func fetchNews()
    func provideUpdateNewsForNewsList(selected channels: String)
    func provideNewsForNewsList(selected channels: String)
    func checkIsSelectedChannels() -> Bool
    func checkCountSelectedChannels() -> Bool
    func findReadedNews()
}

protocol MainScreenDataStoreProtocol {
    var news: [News] { get set }
    var updatedNews: [News] { get set }
    var updatedNewsFromNewsList: [News] { get set }
    var newsForSelectedChannels: [News] { get set }
    var updateNewsForNewsList: [News] { get set }
    var newsForNewsList: [News] { get set }
    var newsRead: [News] { get set }
}

class MainScreenInteractor: MainScreenBusinessLogicProtocol, MainScreenDataStoreProtocol {
    
    var presenter: MainScreenPresentationLogicProtocol?

    var news: [News] = [] {
        didSet {
            getCountUnreadNews()
            getBreakingNews()
            getUrlForReadNews()
            let response = MainNewsList.ShowNews.Response(news: breakingNews, countUnreadNews: countUnreadNews)
            presenter?.presentNews(response: response)
        }
    }
    var updatedNews: [News] = [] {
        didSet {
            getCountUnreadUpdateNews()
            getUpdatedBreakingNews()
            let response = MainNewsList.ShowNews.Response(news: updateBreakingNews, countUnreadNews: countUnreadNews)
            presenter?.presentUpdateNews(response: response)
        }
    }
    
    var updatedNewsFromNewsList: [News] = [] {
        didSet {
            updateNews()
        }
    }

    var newsForSelectedChannels: [News] = [] 
    var updateNewsForNewsList: [News] = []
    var newsForNewsList: [News] = []
    var breakingNews: [News] = []
    var updateBreakingNews: [News] = []
    var newsRead: [News] = [] {
        didSet {
            reloadUpdateNewsWithReadNews()
            reloadNewsWithReadNews()
        }
    }
    var countUnreadNews: [String: Int] = [:]
    var urlForNewsRead: Set<String> = [] {
        didSet {
            StorageManager.shared.setUrlForReadNews(readNews: urlForNewsRead)
        }
    }
    func fetchNews() {

        NetworkManager.shared.fetchData(from:
                                            RequestBuilder()
                                            .set(version: APIVersion.v2)
                                            .set(path: APIURL.topHeadlines)
                                            .setQueryParams(queryType: QueryType.country, queryValue: "us")
                                            .build()
                ) { [ weak self ]result in
                switch result {
                case .success(let news):
                    self?.news = news
                    self?.getNewsForSelectedChannels()
                    self?.getBreakingNews()

                    let response = MainNewsList.ShowNews.Response(
                        news: self?.breakingNews ?? [],
                        countUnreadNews: self?.countUnreadNews ?? [:]
                    )
                    self?.presenter?.presentNews(response: response)
                case .failure(let error):
                    print(error)
            }
        }
    }
   
    // MARK: - MainScreen data preparation logic
    func checkCountSelectedChannels() -> Bool {
        var count = 0
        let currentStatusChannels = StorageManager.shared.fetchStatusSelectedChannels()
        currentStatusChannels.forEach {channel in
            if channel.value {
                count += 1
            }
        }
        return count <= 1
    }
    
    func checkIsSelectedChannels() -> Bool {
        let currentStatusChannels = StorageManager.shared.fetchStatusSelectedChannels()
        let status = currentStatusChannels.contains(where: {$0.value == true})
        
        return status
    }
    
    func findReadedNews() {
        let readedNews = StorageManager.shared.fetchUrlForReadNews()

        for (index, item) in news.enumerated() {
            readedNews.forEach { url in
                if item.url == url {
                    self.news[index].unread = false
                    self.news[index].unbrandening = false
                }
            }
        }
    }

    private func getBreakingNews() {

        for item in newsForSelectedChannels {
            if !breakingNews.contains(where: {$0.source.name == item.source.name}) {
              if let item = news.filter({$0.source.name == item.source.name})
                    .sorted(by: {$0.publishedAt ?? "" > $1.publishedAt ?? "" })
                    .first {
                  breakingNews.append(item)
               }
            }
        }
    }

    private func getUpdatedBreakingNews() {
        updateBreakingNews = []
        getNewsForSelectedChannels()

        for news in newsForSelectedChannels {
            if !updateBreakingNews.contains(where: {$0.source.name == news.source.name}) {
              if let news = updatedNews.filter({$0.source.name == news.source.name})
                    .sorted(by: {$0.publishedAt ?? "" > $1.publishedAt ?? ""})
                    .first {
                  updateBreakingNews.append(news)
               }
            }
        }
    }

    private func reloadUpdateNewsWithReadNews() {
        for newsRead in newsRead {
            for (index, item) in updatedNews.enumerated() {
                if newsRead.url == item.url && newsRead.unread == false {
                    updatedNews[index].unread = false
                    updatedNews[index].unbrandening = false
                }
            }
        }
    }

    private func reloadNewsWithReadNews() {
        for newsRead in newsRead {
            for (index, item) in news.enumerated() {
                if newsRead.url == item.url && newsRead.unread == false {
                    news[index].unread = false
                    news[index].unbrandening = false
                }
            }
        }
    }

    private func getCountUnreadUpdateNews() {
        countUnreadNews = [:]
        let unreadNews = updatedNews.filter { $0.unread == nil }
        for news in unreadNews {
            if !countUnreadNews.contains( where: {$0.key == news.source.name}) {
                countUnreadNews[news.source.name] = 1
            } else {
                countUnreadNews[news.source.name]! += 1
            }
        }
    }

    private func getCountUnreadNews() {
        countUnreadNews = [:]
        let unreadNews = news.filter { $0.unread == nil }
        for news in unreadNews {
            if !countUnreadNews.contains( where: {$0.key == news.source.name}) {
                countUnreadNews[news.source.name] = 1
            } else {
                countUnreadNews[news.source.name]! += 1
            }
        }
    }
    
    private func updateNews() {
        updatedNewsFromNewsList.forEach{ item in
            if !news.contains(where: {$0.url == item.url }) {
                news.append(item)
            }
        }
    }
    
    // MARK: - NewsList data preparation logic
    func provideUpdateNewsForNewsList(selected channels: String) {
        updateNewsForNewsList = updatedNews.filter { $0.source.name == channels }
    }

    func provideNewsForNewsList(selected channels: String) {
        getNewsForSelectedChannels()
        newsForNewsList = newsForSelectedChannels.filter { $0.source.name == channels }
    }
    
    private func getNewsForSelectedChannels() {
        let currentStatusChannels = StorageManager.shared.fetchStatusSelectedChannels()
        newsForSelectedChannels = news.filter { currentStatusChannels[$0.source.name] == true }
    }
    
    // MARK: - User Defaults methods
    private func getUrlForReadNews() {
        news.forEach { news in
            if news.unread == false {
                urlForNewsRead.insert(news.url ?? "")
            }
        }
    }
}

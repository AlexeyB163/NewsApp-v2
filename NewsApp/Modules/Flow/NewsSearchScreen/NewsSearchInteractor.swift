//
//  NewsSearchInteractor.swift
//  NewsApp
//
//  Created by User on 23.06.2022.
//

import Foundation

protocol NewsSearchBusinessLogicProtocol {
    func checkIfIsNews() -> Bool
    func searchNews(queryType: QueryType, query: String)
    func provideUrlSelectedNewsForWeb(selected url: String)
    func getUrlForReadNews()
    func updateFoundNews(url: String)

}

protocol NewsSearchDataStoreProtocol {
    var news: [News] { get set }
    var urlForNewsDetails: String? { get set }

}

class NewsSearchInteractor: NewsSearchBusinessLogicProtocol, NewsSearchDataStoreProtocol {

    var news: [News] = []
    var urlForNewsDetails: String?
    var urlForNewsRead: Set<String> = [] {
        didSet {
            StorageManager.shared.setUrlForReadNews(readNews: urlForNewsRead)
        }
    }
    
    var presenter: NewsSearchPresentationLogicProtocol?
    // var worker: NewsListWorker?
//
    
    
    
    func searchNews(queryType: QueryType, query: String) {

        NetworkManager.shared.fetchData(from:
                                            RequestBuilder()
                                            .set(version: APIVersion.v2)
                                            .set(path: .topHeadlines)
                                            .setQueryParams(queryType: queryType, queryValue: query)
                                            .build()
                ) { [weak self] result in
            
                switch result {
                case .success(let news):
                    self?.news = news
                    self?.findReadedNews()
                    DateConverter.shared.setFormatedDatePublished(news: &self!.news)
                    let response = NewsSearch.ShowNews.Response(news: self?.news ?? [])
                    self?.presenter?.presentNewsSearch(response: response)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func checkIfIsNews() -> Bool {
        news.isEmpty
    }
    

    func provideUrlSelectedNewsForWeb(selected url: String) {
        urlForNewsDetails = url
    }
    
    private func findReadedNews() {
        let readedNews = StorageManager.shared.fetchUrlForReadNews()
        
        for (index, item) in news.enumerated() {
            readedNews.forEach { url in
                let urlFormatedOne = item.url?.replacingOccurrences(of: "http", with: "https")
                let urlFormatedTwo = urlFormatedOne?.replacingOccurrences(of: "httpss", with: "https")
                if urlFormatedTwo == url {
                    self.news[index].unread = false
                    self.news[index].unbrandening = false
                }
            }
        }
    }
    
    func updateFoundNews(url: String) {
        for (index, item) in news.enumerated() {
            if item.url == url {
                news[index].unread = false
                news[index].unbrandening = false
            }
        }
    }
    
    func getUrlForReadNews() {
        news.forEach { news in
            if news.unread == false {
                urlForNewsRead.insert(news.url ?? "")
            }
        }
    }

}

//
//  NewsListInteractor.swift
//  NewsApp
//
//  Created by User on 08.06.2022.
//

import Foundation


 protocol NewsListBusinessLogicProtocol {
    var isUnbrandening: Bool {get set}
    func setFormatedDatePublished()
    func provideNewsList()
    func provideUrlSelectedNewsForWeb(selected url: String)
    func provideUrlReadNews(news: [NewsListCellViewModel])
    func reFetchNews(queryType: QueryType)

}

protocol NewsListDataStoreProtocol {
    var news: [News] { get set }
    var tmpNews: [News] { get set }
    var newsUpdated: [News] { get set }
    var urlForNewsDetails: String? { get set }
    var urlReadNews: [News] { get set }
    var completion: (([News]) -> Void)? { get set }
    var urlForNewsRead: Set<String> { get set }
}



class NewsListInteractor: NewsListBusinessLogicProtocol, NewsListDataStoreProtocol {

    var news: [News] = [] {
        didSet {
            completion?(news)
        }
    }
    var tmpNews: [News] = []
    
    var newsUpdated: [News] = [] {
        didSet {
            getUrlForReadNews()
            let response = NewsList.ShowNews.Response(news: newsUpdated)
            self.presenter?.presentNewsList(response: response)
        }
    }
    
    var urlForNewsDetails: String?
    var isUnbrandening: Bool = false
    var urlReadNews: [News] = []
    var completion: (([News]) -> Void)?
    var urlForNewsRead: Set<String> = [] {
        didSet {
            StorageManager.shared.setUrlForReadNews(readNews: urlForNewsRead)
        }
    }

    var presenter: NewsListPresentationLogicProtocol?
    //var worker: NewsListWorker?

    
    func reFetchNews(queryType: QueryType) {
        guard let query = news.first?.source.name else {
            print("Not a source ID")
            return }
       
        NetworkManager.shared.fetchData(from:
                                            RequestBuilder()
                                            .set(version: APIVersion.v2)
                                            .set(path: .topHeadlines)
                                            .setQueryParams(queryType: queryType, queryValue: query)
                                            .build()
                ) { [ weak self ]result in
            
                switch result {
                case .success(let news):
                    self?.newsUpdated = news
                    self?.findReadedNews()
                    self?.updateNews()
                    
    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func setFormatedDatePublished() {
        DateConverter.shared.setFormatedDatePublished(news: &news)
    }
    
    func provideNewsList() {
        let response = NewsList.ShowNews.Response(news: news)
        presenter?.presentNewsList(response: response)
        
    }

    func provideUrlSelectedNewsForWeb(selected url: String) {
        urlForNewsDetails = url
    }

    func provideUrlReadNews(news: [NewsListCellViewModel]) {

        var readNews: [News] = []

        for item in news {
            readNews.append(News(source: Channel(id: item.id, name: item.source),
                                 title: item.title,
                                 description: item.description,
                                 url: item.url,
                                 urlToImage: item.url,
                                 publishedAt: item.publishedAt,
                                 unread: item.unread,
                                 unbrandening: item.unbrandening))
        }
        self.news = readNews
    }
    
    func getUrlForReadNews() {
        news.forEach { news in
            if news.unread == false {
                urlForNewsRead.insert(news.url ?? "")
            }
        }
    }
    
    func findReadedNews() {
        let readedNews = StorageManager.shared.fetchUrlForReadNews()

        for (index, item) in newsUpdated.enumerated() {
            readedNews.forEach { url in
                if item.url == url {
                    self.newsUpdated[index].unread = false
                    self.newsUpdated[index].unbrandening = false
                }
            }
        }
    }
    
    private func updateNews() {
        tmpNews.forEach{ item in
            if !newsUpdated.contains(where: {$0.url == item.url }) {
                newsUpdated.append(item)
            }
        }
        newsUpdated.sort(by: {$0.publishedAt ?? "" > $1.publishedAt ?? ""})
        DateConverter.shared.setFormatedDatePublished(news: &newsUpdated)
        
        news = newsUpdated
    }
}

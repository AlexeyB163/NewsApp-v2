//
//  RequestBuilder.swift
//  NewsApp
//
//  Created by User on 18.06.2022.
//

import Foundation

enum APIScheme: String {
    case https
}

enum APIHost: String {
    case prod = "newsapi.org"
}

enum APIVersion: String {
    case v1
    case v2
}

enum APIURL: String {
    case topHeadlines = "top-headlines"
}

protocol RequestBuilderProtocol {
    func set(version: APIVersion) -> Self
    func set(path: APIURL) -> Self
    func setQueryParams(queryType name: QueryType, queryValue value: String) -> Self

    func build() -> URL

}
enum QueryType: String {

    case country
    case q
    case sources
    case apiKey = "e79a25a9fd1443168c9f1c9c6003518c"
}

// Создать свой билдер
class RequestBuilder: RequestBuilderProtocol {

   private var urlComponents: URLComponents = {
        var url = URLComponents()
        url.scheme = APIScheme.https.rawValue
        url.host = APIHost.prod.rawValue

        return url
    }()

    func set(version: APIVersion) -> Self {
        urlComponents.path += "/\(version)/"

        return self
    }

    func set(path: APIURL) -> Self {
        urlComponents.path += "\(path.rawValue)"
        return self
    }

    func setQueryParams(queryType name: QueryType, queryValue value: String) -> Self {
        let params: [URLQueryItem] = [
            URLQueryItem(name: name.rawValue, value: value),
            URLQueryItem(name: "apiKey", value: "e79a25a9fd1443168c9f1c9c6003518c")
        ]

        urlComponents.queryItems = params
        return self
    }

    func build() -> URL {
        guard let url = urlComponents.url else { return URL(fileURLWithPath: "")}

        return url
    }
}

//
//  News.swift
//  NewsApp
//
//  Created by User on 03.06.2022.
//

import Foundation

struct SearchResponse: Codable {
    let articles: [News]
}

struct News: Codable {
    var source: Channel
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    var publishedAt: String?
    var unread: Bool?
    var unbrandening: Bool?
}

struct Channel: Codable {
    
    let id: String?
    var name: String
    
}


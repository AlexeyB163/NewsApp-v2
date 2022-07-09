//
//  NetworkManager.swift
//  NewsApp
//
//  Created by User on 03.06.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(from url: URL?, with completion: @escaping(Result<[News], Error>) -> Void ) {
        guard let url = url else {
            print(NetworkError.invalidURL)
            return
            
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(NetworkError.noData)
                return
            }
            do {
                
                let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.articles))
                }
            } catch  {
                print(error)
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}

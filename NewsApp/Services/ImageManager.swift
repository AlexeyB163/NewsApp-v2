//
//  ImageManager.swift
//  NewsApp
//
//  Created by User on 03.06.2022.
//

import Foundation
import UIKit

class ImageManager {
    
    static let shared = ImageManager()
    private var imageCache = NSCache<NSString, UIImage>()
        
    private init() {}
    
    func fetchImageFromCache(url: String, completion: @escaping (UIImage) -> Void) {
        let url = URL(string: url)
        guard let url = url else { return }
        
        if let cacheImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cacheImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
                guard error == nil, data != nil else { return }
                
                guard let image = UIImage(data: data!) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
                
            }
            dataTask.resume()
        }
    }
    
}







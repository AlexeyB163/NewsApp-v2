//
//  DateFormatter.swift
//  NewsApp
//
//  Created by User on 05.07.2022.
//

import Foundation

enum TypePublished: String {
    case current = "CURRENT"
    case overAminute = "MINUTES_AGO"
    case overAHour = "HOURSE_AGO"
    case other = "DAYS_AGO"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
        }

      static func getTitleFor(title:TypePublished) -> String {
            return title.localizedString()
        }

}

class DateConverter {
    
   static let shared = DateConverter()
    
    private func getFormatedDate(datePublished: String) -> Double {
        
        var timeInterval: Double = 0
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
       

        if let date = dateFormatter.date(from: datePublished) {
            timeInterval = currentDate.timeIntervalSince(date) / 60
        } else {
            let datePublished = adjustDatePublished(datePublished: datePublished)
            
            let date = dateFormatter.date(from: datePublished)
            timeInterval = currentDate.timeIntervalSince(date ?? Date()) / 60
        }
        
        return timeInterval
    }
    
    private func adjustDatePublished(datePublished: String) -> String {
        var datePublished: String = datePublished
        
        if datePublished.count > 21 {
            let start = datePublished.index(datePublished.startIndex, offsetBy: 19)
            let end = datePublished.index(datePublished.endIndex, offsetBy: -2)
            let range = start...end
            datePublished.removeSubrange(range)
        }
        
        return datePublished
    }
    
    func setFormatedDatePublished( news: inout [News]) {
        for (index, item) in news.enumerated() {
            let published: String = item.publishedAt ?? ""
            
            let time = Int(ceil(getFormatedDate(datePublished: published)))

            switch time {
            case _ where time > 0 && time < 1 :
                let formatString: String = TypePublished.getTitleFor(title: .current)
                news[index].publishedAt = " \(item.source.name) - \(formatString)"
                
                
            case _ where time >= 1 && time < 60 :
                let formatString: String = TypePublished.getTitleFor(title: .overAminute)
                let resultString = String.localizedStringWithFormat(formatString, time)
                news[index].publishedAt = "\(item.source.name) - \(resultString)"
                
            case _ where time >= 60 && time < 1440 :
                let formatString: String = TypePublished.getTitleFor(title: .overAHour)
                let resultString = String.localizedStringWithFormat(formatString, time / 60)
                news[index].publishedAt = "\(item.source.name) - \(resultString)"
                
            case _ where time >= 1440 :
                let formatString: String = TypePublished.getTitleFor(title: .other)
                
                let resultString = String.localizedStringWithFormat(formatString, time / 60 / 24)
                news[index].publishedAt = "\(item.source.name) - \(resultString)"
            default:
                break
            }
        }
    }
    
    private init() {}
}

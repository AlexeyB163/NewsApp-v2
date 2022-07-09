//
//  ChannelListModels.swift
//  NewsApp
//
//  Created by User on 04.06.2022.
//

import Foundation

protocol CellChannelIdentifiable {
    var identifier: String { get }
    var height: Double { get }
}

enum ChannelsList {
 
    // MARK: Use cases
    enum ShowChannels {
        struct Response {
            let channels: News
            let isSelected: Bool
        }
        
        struct ViewModel {
            struct ChannelCellViewModel: CellChannelIdentifiable {
              
                var identifier: String {
                    "ChannelCell"
                }
                var height: Double {
                    100
                }
                
                let source: String
                let description: String
                let isSelected: Bool
                
                init(news: News, isSelected: Bool) {
                    source = news.source.name
                    description = news.description ?? ""
                    self.isSelected = isSelected
                }
                
            }
     
            let rows:[ChannelCellViewModel]
        }
    }
    
    enum SetSelectedStatus {
        struct Response {
            let isSelected: Bool
        }

        struct ViewModel {
            let isSelected: Bool
        }
    }
    enum DataDelegate {
        struct Response {
            let selectedChannels: [String:Bool]
        }
        struct viewModel {
            let selectedChannels: [String:Bool]
        }
        
    }
}

typealias ChannelCellViewModel = ChannelsList.ShowChannels.ViewModel.ChannelCellViewModel

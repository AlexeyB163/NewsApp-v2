//
//  ChannelListPresenter.swift
//  NewsApp
//
//  Created by User on 04.06.2022.
//

import Foundation

protocol ChannelsListPresentationLogic {
    func presentChannelsList(response: [ChannelsList.ShowChannels.Response])
    func presentSelectedStatus(response: ChannelsList.SetSelectedStatus.Response)
}

class ChannelsListPresenter: ChannelsListPresentationLogic {

    weak var viewController: ChannelsListViewController?
        
    func presentChannelsList(response: [ChannelsList.ShowChannels.Response]) {
        var rows:[ChannelCellViewModel] = []
        response.forEach { item in
            rows.append(ChannelCellViewModel(news: item.channels, isSelected: item.isSelected)) 
        }
        let viewModel = ChannelsList.ShowChannels.ViewModel(rows: rows)
        viewController?.displayChannels(viewModel: viewModel)
    }
    
    func presentSelectedStatus(response: ChannelsList.SetSelectedStatus.Response) {
        let viewModel = ChannelsList.SetSelectedStatus.ViewModel(isSelected: response.isSelected)
        viewController?.displaySelectedStatus(viewModel: viewModel)
    }
}

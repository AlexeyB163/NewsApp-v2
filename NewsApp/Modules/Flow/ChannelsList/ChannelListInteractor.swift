//
//  ChannelListInteractor.swift
//  NewsApp
//
//  Created by User on 04.06.2022.
//

import Foundation

protocol ChannelsListBusinessLogicProtocol {
    var isSelected: Bool {get set}
    func provideListChannels()
    func setSelectedStatus(name: String)
    func provideChannelsForPassingMainScreen(statusChannels: [String: Bool])

}

protocol ChannelsListDataStoreProtocol {
    var news: [News] { get set }
    var selectedChannels: [String: Bool] {get set}
    var newsForSendMainVC: [News] { get set }
    var completion: (([News]) -> Void)? { get set }

}

class ChannelsListInteractor: ChannelsListBusinessLogicProtocol, ChannelsListDataStoreProtocol {

    var isSelected = false
    var newsForSendMainVC: [News] = []
    var news: [News] = []
    var sortedListChannels: [News] = []
    var selectedChannels: [String: Bool] = [:]
    var completion: (([News]) -> Void)?

    var presenter: ChannelsListPresentationLogic?
    var worker: ChannelsWorker?

    func provideListChannels() {
        getSortedChannels()

        var tempListChannels: [ChannelsList.ShowChannels.Response] = []
        sortedListChannels.forEach({
            let currentStatus = worker?.getSelectedStatus(for: $0.source.name) ?? false
            let response = ChannelsList.ShowChannels.Response(
                channels: $0,
                isSelected: currentStatus)

            tempListChannels.append(response)
        })
        presenter?.presentChannelsList(response: tempListChannels)
    }

    func setSelectedStatus(name: String) {
        isSelected = StorageManager.shared.userDefaults.bool(forKey: name)
        isSelected.toggle()
        worker?.setSelectedStatus(for: name, with: isSelected)
        let response = ChannelsList.SetSelectedStatus.Response(isSelected: isSelected)
        presenter?.presentSelectedStatus(response: response)
    }

    private func getSortedChannels() {
        news.forEach { channel in
            if !sortedListChannels.contains(where: {$0.source.name == channel.source.name}) {
                sortedListChannels.append(channel)
            }
        }
    }

    func provideChannelsForPassingMainScreen(statusChannels: [String: Bool]) {

        StorageManager.shared.setStatusSelectedChannels(selectedChannels: statusChannels)

        news.forEach { news in
            if statusChannels.contains(where: {$0.key == news.source.name && $0.value == true}) {
                newsForSendMainVC.append(news)
            }
        }

        let news = news.filter { statusChannels[$0.source.name] == true }
        completion?(news)

    }

}

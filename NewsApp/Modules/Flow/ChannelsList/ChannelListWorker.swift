//
//  ChannelListWorker.swift
//  NewsApp
//
//  Created by User on 04.06.2022.
//

import Foundation

class ChannelsWorker {
    func getSelectedStatus(for channelName: String) -> Bool {
        StorageManager.shared.getSelectedStatus(for: channelName)
    }
    
    func setSelectedStatus(for channelName: String, with status: Bool) {
        StorageManager.shared.setSelectedStatus(for: channelName, with: status)
    }
    
    func setDefaultStatus(for channelName: String, with status: Bool) {
        StorageManager.shared.setDefaultStatus(for: channelName, with: status)
    }
}

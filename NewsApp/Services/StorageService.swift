//
//  StorageManager.swift
//  NewsApp
//
//  Created by User on 03.06.2022.
//

import Foundation

class StorageManager {

    static let shared = StorageManager()

    private init() {}

    let userDefaults = UserDefaults.standard

    func setSelectedStatus(for channelName: String, with status: Bool) {
        userDefaults.set(status, forKey: channelName)
    }

    func getSelectedStatus(for channelName: String) -> Bool {
        return userDefaults.bool(forKey: channelName)
    }

    func setDefaultStatus(for channelName: String, with status: Bool) {
        userDefaults.set(status, forKey: channelName)
    }

    func removeAllSelectedChannels(channelName: [News]) {
        channelName.forEach({
            userDefaults.removeObject(forKey: $0.source.name)
        })
    }

    func setStatusSelectedChannels( selectedChannels: [String: Bool]) {

        guard let data = try? JSONEncoder().encode(selectedChannels) else {
            print("error set status selected channels")
            return }
        userDefaults.set(data, forKey: "selectedChannels")
    }

    func fetchStatusSelectedChannels() -> [String: Bool] {
        guard let data = userDefaults.data(forKey: "selectedChannels") else {
            print("error get Data for status selected channels")
            return [:]
        }
        guard let statusChannels = try? JSONDecoder().decode([String: Bool].self, from: data) else {
            print("error get status selected channels")
            return [:]
        }
        return statusChannels
    }
    
    func setUrlForReadNews( readNews: Set<String>) {

        guard let data = try? JSONEncoder().encode(readNews) else {
            print("error set url for read news")
            return }
        userDefaults.set(data, forKey: "urlReadNews")
    }
    
    func fetchUrlForReadNews() -> Set<String> {
        guard let data = userDefaults.data(forKey: "urlReadNews") else {
            print("error get Data for url read news")
            return []
        }
        guard let url = try? JSONDecoder().decode(Set<String>.self, from: data) else {
            print("error get url for read news")
            return []
        }
        return url
    }
    
    func removeAllReadedUrl() {
        userDefaults.removeObject(forKey: "urlReadNews")
    }
    
}

//
//  NewsListConfigurator.swift
//  NewsApp
//
//  Created by User on 03.06.2022.
//

import Foundation

final class MainScreenConfigurator {
    
    static let shared = MainScreenConfigurator()
    
    private init() {}
    
    func configur(with viewController: MainScreenViewController) {
        let viewController = viewController
        let interactor = MainScreenInteractor()
        let presenter = MainScreenPresenter()
        let router = MainScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}

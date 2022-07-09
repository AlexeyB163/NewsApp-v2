//
//  NewsSearchConfigurator.swift
//  NewsApp
//
//  Created by User on 23.06.2022.
//

import Foundation
import UIKit

final class NewsSearchConfigurator {

    static let shared = NewsSearchConfigurator()

    private init() {}

    func build(viewController: NewsSearchViewController ) {
        let viewController = viewController
        let interactor = NewsSearchInteractor()
        let presenter = NewsSearchPresenter()
        let router = NewsSearchRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

    }
}

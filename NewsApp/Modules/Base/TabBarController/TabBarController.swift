//
//  TabBarController.swift
//  NewsApp
//
//  Created by User on 04.06.2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainVC = MainScreenViewController()
        let searchVC = NewsSearchViewController()

        let configureItem = UIImage.SymbolConfiguration(weight: .semibold)
        let imageItem = UIImage(systemName: "square.fill", withConfiguration: configureItem)

        viewControllers = [
            setupNavigationController(
                rootViewController: mainVC,
                title: String(localized: "title_tabBar_news"),
                image: imageItem ?? UIImage()
            ),
            setupNavigationController(
                rootViewController: searchVC,
                title: String(localized: "title_tabBar_searchNews"),
                image: imageItem ?? UIImage())
        ]
        

    }
    
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        self.editButtonItem.title = editing ? "cancel" : "change"
//    }

    private func setupNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        
        return navigationVC
    }

}

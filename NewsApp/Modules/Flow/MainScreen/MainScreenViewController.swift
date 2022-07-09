//
//  ViewController.swift
//  NewsApp
//
//  Created by User on 03.06.2022.
//

import UIKit

protocol MainScreenDisplayLogicProtocol: AnyObject {

    func displayMainNews(viewModel: MainNewsList.ShowNews.ViewModel)
    func updateNews(viewModel: MainNewsList.ShowNews.ViewModel)

}

class MainScreenViewController: UIViewController {
    var interactor: MainScreenBusinessLogicProtocol?
    var router: (NSObjectProtocol & MainScreenRoutingLogicProtocol & MainScreenDataPassingProtocol)?

    private var items: [MainNewsCellViewModel] = []

    enum Section: Int, CaseIterable {
        case single
        case grid

        var countColumn: Int {
            switch self {
            case .single:
               return 1
            case .grid:
               return 2
            }
        }
    }

    var collectionView: UICollectionView! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.findReadedNews()
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        MainScreenConfigurator.shared.configur(with: self)
        setupNavigationBar()
        setupCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        getNews()
        
        if !checkStatusSelectedChannels() {
            setPlugForScreen()
        }
    }

    private func getNews() {
        interactor?.fetchNews()
        
    }
    
    private func checkStatusSelectedChannels() -> Bool {
       let status = interactor?.checkIsSelectedChannels()
        return status ?? true
    }
    
    private func setPlugForScreen() {
        let label = UILabel()
        label.text = String(localized: "select_channels")
        label.font = .systemFont(ofSize: 50, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        collectionView.backgroundView = label
        
    }

    @objc private func changeChannels() {
        router?.routeToChannelsList()
    }
}

// MARK: - MainScreenDisplayLogic
extension MainScreenViewController: MainScreenDisplayLogicProtocol {

    func displayMainNews(viewModel: MainNewsList.ShowNews.ViewModel) {
        items = viewModel.items
        collectionView.reloadData()
    }

    func updateNews(viewModel: MainNewsList.ShowNews.ViewModel) {
        items = viewModel.items
        collectionView?.reloadData()
        
        if checkStatusSelectedChannels() {
            collectionView.backgroundView = nil
            return
        }
        setPlugForScreen()
    }
}

// MARK: - Setup CollectionView
extension MainScreenViewController {
    func setupCollectionView() {

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: setupLayout())

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)

        collectionView.register(AllNewsCell.self, forCellWithReuseIdentifier: "MainNewsCell")
        
    }

// MARK: - Setup Layout
    private func setupLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {(sectionIndex, _) -> NSCollectionLayoutSection? in

            guard let sectionKind = Section(rawValue: sectionIndex) else {return nil}
            let columns = sectionKind.countColumn

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            let groupHeight = columns == 1 ?
            NSCollectionLayoutDimension.fractionalWidth(0.5) : NSCollectionLayoutDimension.fractionalWidth(0.5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

            return section
        }
        return layout
    }

    // MARK: - Setup NavigationBar
    private func setupNavigationBar() {

        navigationItem.title = String(localized: "mainScreen_title")
        navigationController?.navigationBar.backgroundColor = .systemBackground
        let rightButton = UIBarButtonItem(title: String(localized: "title_edit_button"), style: .done, target: self, action: #selector(changeChannels))
        navigationItem.rightBarButtonItem = rightButton
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if interactor?.checkCountSelectedChannels() ?? true {
            return 1
        } else {
            return 2
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if items.isEmpty {
            return 0
        } else {
            switch section {
            case 0:
                return 1
            default:
               return items.count
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if items.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainNewsCell" , for: indexPath) as! AllNewsCell
            return cell
        }
        
        let cellViewModel = items[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModel.identifier, for: indexPath) as? AllNewsCell else { return UICollectionViewCell() }
        cell.viewModel = cellViewModel
        cell.configure()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.provideUpdateNewsForNewsList(selected: items[indexPath.item].source)
        interactor?.provideNewsForNewsList(selected: items[indexPath.item].source)
        router?.routeToNewsList()
    }
}

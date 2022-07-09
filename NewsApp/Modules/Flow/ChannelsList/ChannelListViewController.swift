//
//  ChannelListViewController.swift
//  NewsApp
//
//  Created by User on 04.06.2022.
//

import UIKit

protocol ChannelsListDisplayLogicProtocol: AnyObject {
    func displayChannels(viewModel: ChannelsList.ShowChannels.ViewModel)
    func displaySelectedStatus(viewModel: ChannelsList.SetSelectedStatus.ViewModel)
}

class ChannelsListViewController: UIViewController {

    var interactor: ChannelsListBusinessLogicProtocol?

    var statusSwitch: Bool?
    var tempStatusChannel: [String: Bool] = [:]
    var selectedChannels: [String: Bool] = [:]
    private var rows: [ChannelCellViewModel] = []

    let tableView = UITableView()

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        passRequest()
        tableView.dataSource = self
        tableView.delegate = self
        setupTableView()
        setupConstraint()

    }

    private func passRequest() {

        interactor?.provideListChannels()
        tableView.reloadData()
    }

}

// MARK: - DisplayLogicProtocol
extension ChannelsListViewController: ChannelsListDisplayLogicProtocol {

    func displayChannels(viewModel: ChannelsList.ShowChannels.ViewModel) {
        rows = viewModel.rows
    }

    func displaySelectedStatus(viewModel: ChannelsList.SetSelectedStatus.ViewModel) {
        statusSwitch = viewModel.isSelected
    }
}

// MARK: - Setup NavigationBar
extension ChannelsListViewController {

    private func setupNavigationBar() {
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissScreen))
        navigationItem.title = String(localized: "title_ChannelsList")
        navigationItem.rightBarButtonItem = buttonDone
        navigationController?.navigationBar.backgroundColor = .white
    }

    @objc private func dismissScreen() {
        interactor?.provideChannelsForPassingMainScreen(statusChannels: tempStatusChannel)

        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup TableView
extension ChannelsListViewController {

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(ChannelCell.self, forCellReuseIdentifier: "ChannelCell")

    }

    private func setupConstraint() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChannelsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = rows[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.identifier, for: indexPath) as? ChannelCell else { return UITableViewCell()}

        cell.viewModel = cellViewModel
        let switchView = UISwitch()
        cell.accessoryView = switchView

        if !tempStatusChannel.keys.contains(where: {$0 == cellViewModel.source}) {
            tempStatusChannel[cellViewModel.source] = cellViewModel.isSelected
            switchView.setOn(tempStatusChannel[cellViewModel.source]!, animated: true)
        } else {
            switchView.setOn(tempStatusChannel[cellViewModel.source]!, animated: true)
        }

        switchView.addAction(UIAction(handler: { [self] _ in
            self.interactor?.setSelectedStatus(name: cellViewModel.source)
            tempStatusChannel[cellViewModel.source] = statusSwitch
            }
        ), for: .valueChanged)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rows[indexPath.row].height
    }
    
    
}

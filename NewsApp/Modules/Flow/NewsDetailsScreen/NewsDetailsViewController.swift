//
//  NewsScreenViewController.swift
//  NewsApp
//
//  Created by User on 21.06.2022.
//

import UIKit
import WebKit

class NewsDetailsViewController: UIViewController {

    var url: String? {
        didSet {
            displayNews()
        }
    }
    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupConstraint()
    }

    private func setupWebView() {
        view.addSubview(webView)
    }

    private func setupConstraint() {
        webView.translatesAutoresizingMaskIntoConstraints = false

        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func displayNews() {
        guard let url = URL(string: url ?? "") else { return}
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

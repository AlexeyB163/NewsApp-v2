//
//  NewsScreenViewController.swift
//  NewsApp
//
//  Created by User on 21.06.2022.
//

import UIKit
import WebKit

class NewsDetailsViewController: UIViewController{

    var url: String? {
        didSet {
            activityIndicatorView.startAnimating()
            displayNews()
        }
    }
    let webView = WKWebView()
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    private var observation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupConstraint()
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.center = self.view.center
        
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
        self.observation = webView.observe(\WKWebView.estimatedProgress, options: .new) { _, change in
            self.activityIndicatorView.stopAnimating()
        }
    }
}

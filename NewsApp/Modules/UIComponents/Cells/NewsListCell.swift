//
//  NewsListCell.swift
//  NewsApp
//
//  Created by User on 21.06.2022.
//

import Foundation
import UIKit

protocol CellNewsListModelRepresentable {
    var viewModel: CellNewsListIdentifiableProtocol? { get set }

}

class NewsListCell: UITableViewCell, CellNewsListModelRepresentable {

    var viewModel: CellNewsListIdentifiableProtocol? {
        didSet {
            configure(unbrandering: true)
        }
    }

    private let newsImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false

        return image
    }()

    private let publishedAtLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let unbranderingLabel: UILabel  = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let unbranderingIndicate: UIImageView  = {
        let image = UIImage()
        var imageView = UIImageView()
        
        imageView = UIImageView(frame: CGRect(x: 210, y: 36, width: 10, height: 10))
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.image = image
        
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupTableViewCell()
        setupConstraints()

    }

    private func setupTableViewCell() {
        
        contentView.addSubview(newsImage)
        contentView.addSubview(publishedAtLabel)
        contentView.addSubview(unbranderingLabel)
        contentView.addSubview(unbranderingIndicate)
        contentView.addSubview(descriptionLabel)
    }

    func configure(unbrandering: Bool) {
        guard let viewModel = viewModel as? NewsListCellViewModel else { return }

        ImageManager.shared.fetchImageFromCache(url: viewModel.imageURL) { image in
            DispatchQueue.main.async {
                self.newsImage.image = image
            }
            
        }
        unbranderingLabel.text = String(localized: "unbrandering")
        publishedAtLabel.text = viewModel.publishedAt
        descriptionLabel.text = viewModel.description
        
        
        if unbrandering {
            unbranderingIndicate.backgroundColor = .green
        } else {
            unbranderingIndicate.backgroundColor = .gray
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {

        newsImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        newsImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        newsImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        newsImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        publishedAtLabel.leftAnchor.constraint(equalTo: newsImage.rightAnchor, constant: 10).isActive = true
        publishedAtLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true

        unbranderingLabel.leftAnchor.constraint(equalTo: newsImage.rightAnchor, constant: 10).isActive = true
        unbranderingLabel.topAnchor.constraint(equalTo: publishedAtLabel.bottomAnchor, constant: 5).isActive = true

        descriptionLabel.topAnchor.constraint(equalTo: unbranderingLabel.bottomAnchor, constant: 0).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: newsImage.rightAnchor, constant: 10).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        

    }

}

//
//  AllNewsCell.swift
//  NewsApp
//
//  Created by User on 03.06.2022.
//

import Foundation
import UIKit

protocol CellNewsModelRepresentable {
    var viewModel: CellMainScreenIdentifiableProtocol? { get set }
}

class AllNewsCell: UICollectionViewCell, CellNewsModelRepresentable {

    var viewModel: CellMainScreenIdentifiableProtocol? {
        didSet {
            configure()
        }
    }

    private let newsImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        image.translatesAutoresizingMaskIntoConstraints = false

        return image
    }()

    private let titleLabel: UILabel  = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .systemCyan
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let unreadLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGray
        label.backgroundColor = .white
        label.layer.borderWidth = 0.4
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(frame: CGRect) {
        super .init(frame: frame)
        setupConstraints()
        backgroundColor = .white
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        
    }
 // MARK: - Configure cell
    func configure() {
        guard let viewModel = viewModel as? MainNewsCellViewModel else { return }
        titleLabel.text = viewModel.source
        
        ImageManager.shared.fetchImageFromCache(url: viewModel.imageURL) { image in
            
            DispatchQueue.main.async {
                self.newsImage.image = image
            }
        }
        descriptionLabel.text = viewModel.description

        if viewModel.countUnreadNews[viewModel.source] ?? 0 < 1 {
            unreadLabel.text = String(localized: "status_unread")
        } else {
            let count = String(viewModel.countUnreadNews[viewModel.source] ?? 0)
            unreadLabel.text = "\(count) \(String(localized: "unread")) "
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImage.image = nil
    }

}

// MARK: - Setup Constraints
extension AllNewsCell {

    func setupConstraints() {
        contentView.addSubview(unreadLabel)
        contentView.addSubview(newsImage)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(titleLabel)

        
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true

        newsImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        newsImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        newsImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        newsImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.frame.height/2.2).isActive = true

        unreadLabel.layer.zPosition = 1
        unreadLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        unreadLabel.bottomAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: -5).isActive = true

        descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true

    }
}

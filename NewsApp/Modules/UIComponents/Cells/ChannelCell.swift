//
//  ChannelCell.swift
//  NewsApp
//
//  Created by User on 06.06.2022.
//

import Foundation
import UIKit

protocol CellChannelModelRepresentable {
    var viewModel: CellChannelIdentifiable? { get set }
    
}

class ChannelCell: UITableViewCell, CellChannelModelRepresentable {
    
    var viewModel: CellChannelIdentifiable? {
        didSet {
            configure()
        }
    }

    private let titleLabel: UILabel  = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTableViewCell()
        setupConstraints()
        
    }
    
    private func setupTableViewCell() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    func configure() {
        guard let viewModel = viewModel as? ChannelCellViewModel else { return }
        
        titleLabel.text = viewModel.source
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor , constant: 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: 0).isActive = true
        
    }
    
    
}

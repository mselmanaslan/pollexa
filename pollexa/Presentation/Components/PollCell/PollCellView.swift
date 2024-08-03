//
//  PollCellView.swift
//  pollexa
//
//  Created by Selman Aslan on 9.06.2024.
//

import UIKit
import SnapKit

class PollCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 5
        return label
    }()
    
    private let addedByLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "ButtonColor")
        label.numberOfLines = 0
        return label
    }()
    
    private let totalVotesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        return label
    }()
    
    private let totalVotesIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowshape.up")
        imageView.tintColor = UIColor(named: "TextColor")
        return imageView
    }()
    
    private var viewModel: PollCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        backgroundColor = UIColor(named: "MainBackgroundColor")
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(addedByLabel)
        containerView.addSubview(totalVotesIcon)
        containerView.addSubview(totalVotesLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        addedByLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(addedByLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        totalVotesIcon.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        totalVotesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalVotesIcon)
            make.leading.equalTo(totalVotesIcon.snp.trailing).offset(3)
        }
    }
    
    func configure(with viewModel: PollCellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        addedByLabel.text = viewModel.addedBy
        totalVotesLabel.text = viewModel.totalVotes
    }
}

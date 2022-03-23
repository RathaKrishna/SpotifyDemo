//
//  SearchResultsDefaultTableViewCell.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/23.
//

import UIKit


class SearchResultsDefaultTableViewCell: UITableViewCell {

    static let identifier = "SearchResultsDefaultTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    private let subTitleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.isHidden = true
        return label
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.height - 4
        iconImageView.frame = CGRect(x: 10, y: 2, width: imageSize, height: imageSize)
       
//        iconImageView.snp.makeConstraints { make in
//            make.left.equalTo(10)
//            make.top.equalToSuperview()
//            make.width.height.equalTo(imageSize)
//        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.equalTo(10)
            make.top.equalTo(10)
        }
//
        subTitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = ""
        subTitleLabel.text = ""
    }
    
    func configure(with viewModel: SearchResultsDefaultCellViewModel) {
        titleLabel.text = viewModel.title
        iconImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
        
        guard let subTitle = viewModel.subTitle else
        {
            return
        }
        subTitleLabel.text = subTitle
        subTitleLabel.isHidden = false
        layoutIfNeeded()
    }
}

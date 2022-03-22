//
//  RecommendedTrackCollectionViewCell.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/16.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    private let trackCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(trackCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height - 5
        
        trackCoverImageView.snp.makeConstraints { make in
            make.left.top.equalTo(5)
            make.width.height.equalTo(imageSize)
        }
        trackNameLabel.snp.makeConstraints { make in
            make.left.equalTo(trackCoverImageView.snp.right).offset(10)
            make.top.right.equalTo(5)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-30)
        }
        artistNameLabel.snp.makeConstraints { make in
            make.left.equalTo(trackNameLabel)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        trackCoverImageView.image = nil
    }
    
    func configure(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
       
        trackCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}

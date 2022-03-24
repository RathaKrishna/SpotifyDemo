//
//  FeaturedPlaylistCollectionViewCell.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/16.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"

    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playlistCoverImageView.snp.makeConstraints { make in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(contentView.snp.bottom).offset(-60)
            make.width.equalToSuperview()
        }
        playlistNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(2)
            make.top.equalTo(playlistCoverImageView.snp.bottom).offset(3)
        }
        creatorNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(2)
            make.top.equalTo(playlistNameLabel.snp.bottom).offset(3)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
       
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}

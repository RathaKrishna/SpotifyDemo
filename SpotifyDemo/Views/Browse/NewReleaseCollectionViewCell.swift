//
//  NewReleaseCollectionViewCell.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/16.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private let numberOfTracksLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    private let artistNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        
        albumCoverImageView.snp.makeConstraints { make in
            make.left.top.equalTo(5)
            make.width.height.equalTo(imageSize)
        }
        albumNameLabel.snp.makeConstraints { make in
            make.left.equalTo(albumCoverImageView.snp.right).offset(10)
            make.top.right.equalTo(5)
        }
        artistNameLabel.snp.makeConstraints { make in
            make.left.equalTo(albumNameLabel)
            make.top.equalTo(albumNameLabel.snp.bottom)
        }
        numberOfTracksLabel.snp.makeConstraints { make in
            make.left.equalTo(albumNameLabel)
            make.top.equalTo(artistNameLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleaseCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}

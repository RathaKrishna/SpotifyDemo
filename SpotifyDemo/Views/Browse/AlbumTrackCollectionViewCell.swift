//
//  AlbumTrackCollectionViewCell.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/21.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlbumTrackCollectionViewCell"
    
   
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
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        trackNameLabel.snp.makeConstraints { make in
            make.top.right.left.equalTo(10)
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
    }
    
    func configure(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
       
    }
    
}

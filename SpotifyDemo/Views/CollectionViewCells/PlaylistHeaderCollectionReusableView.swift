//
//  PlaylistHeaderCollectionReusableView.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/18.
//

import UIKit
import SDWebImage
import SnapKit

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "no_img")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
//        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
//        label.textAlignment = .center
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
//        label.textAlignment = .center
        return label
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        [self.nameLabel, self.descriptionLabel, self.ownerLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let playAllButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))

        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
//        addSubview(stackView)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapPlayAll() {
        //Play all button clicked
        delegate?.playlistHeaderReusableViewDidTapPlayAll(self)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = height/1.8
        
        imageView.frame = CGRect(x: (width-imageSize) / 2, y: 20, width: imageSize, height: imageSize)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(imageView.snp.bottom).offset(6)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }
       
        ownerLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(2)
        }

        playAllButton.frame = CGRect(x: width - 80, y: height - 80, width: 60, height: 60)
    }
    
    // MARK: - Configure
    func configure(with viewModel: PlaylistHeaderCollectionViewModel) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.ownerName
        imageView.sd_setImage(with: viewModel.artWorkUrl, placeholderImage: UIImage(named: "no_img"), completed: nil)
    }
}

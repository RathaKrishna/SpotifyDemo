//
//  PlaylistsTableViewCell.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/25.
//

import UIKit

struct PlaylistsTableViewCellViewModel {
    let imgUrl: URL?
    let name: String
}
class PlaylistsTableViewCell: UITableViewCell {
    
    static let identifier = "PlaylistsTableViewCell"

    private let imgView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.layer.cornerRadius = 3
        imgV.layer.masksToBounds = true
        return imgV
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(imgView)
        contentView.addSubview(nameLabel)
        accessoryType = .disclosureIndicator
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       
        imgView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.width.height.equalTo(70)
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(10)
            make.center.equalToSuperview()
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        nameLabel.text = ""
    }
    
    func configure(with viewModel: PlaylistsTableViewCellViewModel) {
        
        nameLabel.text = viewModel.name

        imgView.sd_setImage(with: viewModel.imgUrl,placeholderImage: UIImage(named: "no_img"), completed: nil)
    }
    
    

}

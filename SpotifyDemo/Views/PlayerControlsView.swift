//
//  PlayerControlsView.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/23.
//

import Foundation
import UIKit

final class PlayerControlsView: UIView {
    
    private let volumeSlider: UISlider = {
       let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Title goes here"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    private let subTitleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.text = "subtitle goes here"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    private let playPausButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        [self.backButton, self.playPausButton, self.forwardButton].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        addSubview(volumeSlider)
        addSubview(nameLabel)
        addSubview(subTitleLabel)
        addSubview(stackView)
//        addSubview(backButton)
//        addSubview(forwardButton)
//        addSubview(playPausButton)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().offset(10)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        volumeSlider.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(volumeSlider.snp.bottom).offset(30)
            make.height.equalTo(80)
        }
    }
}

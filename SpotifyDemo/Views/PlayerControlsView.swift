//
//  PlayerControlsView.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/23.
//

import Foundation
import UIKit
import AQPlayer

protocol PlayerControlsViewDelegate: AnyObject {
    func playerDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playerDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playerDidTapBackwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsView(_ playControlsView: PlayerControlsView, didSlideSlider value: Float)
    func playerControlsView(_ playControlsView: PlayerControlsView, didFinishSlider value: Float)
}

struct PlayerControlsViewViewModel {
    var title: String
    var subTitle: String
}

final class PlayerControlsView: UIView {
    private var isPlaying = true
    
    weak var delegate: PlayerControlsViewDelegate?
    
    public let progressSlider: UISlider = {
       let slider = UISlider()
        slider.value = 0
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.tintColor = .systemGreen
        return slider
    }()
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    private let subTitleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    public let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    public let forwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    private let playPausButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    public let timeLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.text = "00:00"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()
    
    public let remainLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.text = "00:00"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        [self.backButton, self.playPausButton, self.forwardButton].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(progressSlider)
        addSubview(nameLabel)
        addSubview(subTitleLabel)
        addSubview(stackView)
        addSubview(timeLabel)
        addSubview(remainLabel)
//        addSubview(playPausButton)
        clipsToBounds = true
        progressSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        progressSlider.addTarget(self, action: #selector(didSlideFinish(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        playPausButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    // MARK: - Player Controls button actions
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    @objc func didSlideFinish(_ slider: UISlider) {
        delegate?.playerControlsView(self, didFinishSlider: slider.value)
    }
    
    @objc private func didTapBack() {
        delegate?.playerDidTapBackwardButton(self)
    }
    @objc private func didTapForward() {
        delegate?.playerDidTapForwardButton(self)
    }
    @objc private func didTapPlayPause() {
//        self.isPlaying = !isPlaying
        delegate?.playerDidTapPlayPauseButton(self)
        
       
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
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
        }
        remainLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
        }
        progressSlider.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(timeLabel.snp.bottom)
            make.height.equalTo(44)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(progressSlider.snp.bottom).offset(20)
            make.height.equalTo(80)
        }
        
        
    }
    public func configPlayButton(status: AQPlayerStatus) {
        var buttonImg: UIImage?
        switch status {
        case .none, .loading, .failed, .readyToPlay, .paused:
            buttonImg = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        case .playing:
            buttonImg = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
            
        }
       
            playPausButton.setImage(buttonImg, for: .normal)
        
       
        
    }
    
    public func configure(with viewModel: PlayerControlsViewViewModel) {
        nameLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
    }
}

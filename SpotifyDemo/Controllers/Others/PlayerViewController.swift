//
//  PlayerViewController.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/10.
//

import UIKit

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
} 

class PlayerViewController: UIViewController {

    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    private var imageView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = .systemBlue
        imgV.contentMode = .scaleAspectFill
        return imgV
    }()
    
    private let controlsView = PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        configure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top)
            make.left.right.equalTo(0)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.height/3)
        }
        controlsView.snp.makeConstraints { make in
            make.left.right.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    private func configureBarButtons() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    @objc func didTapAction() {
        //Actions
    }
    
    func refreshUI() {
        configure()
    }
    
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageUrl , completed: nil)
        controlsView.configure(with: PlayerControlsViewViewModel(title: dataSource?.songName ?? "-", subTitle: dataSource?.subTitle ?? "--"))
    }
}

extension PlayerViewController: PlayerControlsViewDelegate {
    
    func playerControlsView(_ playControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func playerControlsView(_ playControlsView: PlayerControlsView, didFinishSlider value: Float) {
//        delegate?.didSlideSlider(value)
    }
    
    func playerDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        //Play and Pause
        delegate?.didTapPlayPause()
    }
    
    func playerDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        // Next track
        delegate?.didTapForward()
    }
    
    func playerDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        // Previous track
        delegate?.didTapBackward()
    }
    
    
}

//
//  AudioPlayerViewController.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/26.
//

import UIKit
import AQPlayer



class AudioPlayerViewController: UIViewController {

    
    private let controlsView = PlayerControlsView()
    private var tracks = [AudioTrack]()
    private var track: AudioTrack?
    
    let playerManager = AQPlayerManager.shared
    var playeritems: [AQPlayerItemInfo] = []
    var remoteControlMode: AQRemoteControlMode = .skip
    
    var currentTrack = 0
    
    private var imageView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = .systemBlue
        imgV.contentMode = .scaleAspectFill
        return imgV
    }()
    
    init(tracks: [AudioTrack]) {
        super.init(nibName: nil, bundle: nil)
        self.tracks = tracks
        
       
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        
        configureBarButtons()
        loadData()
        track = tracks[currentTrack]
        configure()
        setupPlayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top)
            make.left.right.equalTo(0)
            make.width.height.equalTo(view.snp.width)
        }
        controlsView.snp.makeConstraints { make in
            make.left.right.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        playerManager.pause()
        
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
    
    
    private func loadData() {
        playeritems.removeAll()
        for i in 0..<self.tracks.count {
            let track = self.tracks[i]
            let item = AQPlayerItemInfo(
                id: i,
                url: URL(string: track.preview_url ?? ""),
                title: track.name,
                albumTitle: track.album?.name,
                coverImageURL: track.album?.images.first?.url ?? "",
                startAt: 0)
            playeritems.append(item)
        }
    }
    
    
    private func configure() {
        imageView.sd_setImage(with: URL(string: track?.album?.images.first?.url ?? "") ,placeholderImage: UIImage(named: "no_img"), completed: nil)
        controlsView.configure(with: PlayerControlsViewViewModel(title: track?.name ?? "-", subTitle: track?.artists.first?.name ?? "--"))
    }
    
    private func setupPlayer() {
        // setup player manager
        playerManager.delegate = self
        playerManager.setup(with: playeritems, startFrom: 0, playAfterSetup: false)
        playerManager.skipIntervalInSeconds = 20.0
        playerManager.play()
    }
    
    private func stringFromTimeInterval(interval: TimeInterval) -> String {
        if interval.isNaN {
            return ""
        }
        
        let ti = NSInteger(interval)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        if hours > 0 {
            return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        } else {
            return String(format: "%0.2d:%0.2d",minutes,seconds)
        }
    }
    
}


extension AudioPlayerViewController: PlayerControlsViewDelegate {
    
    func playerControlsView(_ playControlsView: PlayerControlsView, didFinishSlider value: Float) {
//        delegate?.didSlideSlider(value)
        controlsView.progressSlider.isEnabled = false
        playerManager.seek(toPercent: Double(value))
        controlsView.progressSlider.isEnabled = true
    }
    
    func playerControlsView(_ playControlsView: PlayerControlsView, didSlideSlider value: Float) {
//        delegate?.didSlideSlider(value)
        controlsView.timeLabel.text = self.stringFromTimeInterval(interval: TimeInterval(controlsView.progressSlider.value * Float(playerManager.duration)))
       
    }
    
    func playerDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        //Play and Pause
//        delegate?.didTapPlayPause()
        let status = playerManager.playOrPause()
        
        controlsView.configPlayButton(status: status)
    }
    
    func playerDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        // Next track
        playerManager.next()
    }
    
    func playerDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        // Previous track
        playerManager.previous()
    }
    
    
}

extension AudioPlayerViewController: AQPlayerDelegate {
    func aQPlayerManager(_ playerManager: AQPlayerManager, progressDidUpdate percentage: Double) {
        
        guard controlsView.progressSlider.isEnabled && !controlsView.progressSlider.isTracking else {
            return
        }
        
        controlsView.progressSlider.setValue(Float(percentage), animated: true)
        
        controlsView.timeLabel.text = self.stringFromTimeInterval(interval: playerManager.currentTime)
        controlsView.remainLabel.text = self.stringFromTimeInterval(interval:(playerManager.duration - playerManager.currentTime))
        
    }
    
    func aQPlayerManager(_ playerManager: AQPlayerManager, itemDidChange itemIndex: Int) {
        currentTrack = itemIndex
        self.track = self.tracks[itemIndex]
        refreshUI()
        controlsView.backButton.isEnabled = itemIndex > 0
        controlsView.forwardButton.isEnabled = itemIndex < self.playeritems.count - 1
    }
    
    func aQPlayerManager(_ playerManager: AQPlayerManager, statusDidChange status: AQPlayerStatus) {
        
    }
    
    func getCoverImage(_ player: AQPlayerManager, _ callBack: @escaping (UIImage?) -> Void) {
        
    }
    
    
}

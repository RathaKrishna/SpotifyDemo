//
//  PlayerPresenter.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/25.
//

import Foundation
import AQPlayer

final class PlayerPresenter {
    
    static let shared = PlayerPresenter()
    
    private var tracks = [AudioTrack]()
    
    let playerManager = AQPlayerManager.shared
    var playeritems: [AQPlayerItemInfo] = []
    var remoteControlMode: AQRemoteControlMode = .skip
    
    var currentTrack = 0
    // play entire tracks
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]) {
            
            self.tracks = tracks
            loadData()
            // setup player manager
            playerManager.delegate = self
            playerManager.setup(with: playeritems, startFrom: 0, playAfterSetup: false)
            playerManager.skipIntervalInSeconds = 20.0
            
            let vc = PlayerViewController()
            vc.dataSource = self
            vc.delegate = self
            viewController.present(UINavigationController(rootViewController: vc), animated: true)
            playerManager.play()
        }
    
    private func loadData() {
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
    
    
}

extension PlayerPresenter: AQPlayerDelegate {
    func aQPlayerManager(_ playerManager: AQPlayerManager, progressDidUpdate percentage: Double) {
        
    }
    
    func aQPlayerManager(_ playerManager: AQPlayerManager, itemDidChange itemIndex: Int) {
        currentTrack = itemIndex
    }
    
    func aQPlayerManager(_ playerManager: AQPlayerManager, statusDidChange status: AQPlayerStatus) {
        
    }
    
    func getCoverImage(_ player: AQPlayerManager, _ callBack: @escaping (UIImage?) -> Void) {
        
    }
    
    
}

extension PlayerPresenter: PlayerViewControllerDelegate {
    func didTapPlayPause() {
        let status = playerManager.playOrPause()
        print("play status \(status)")
//        setPlayPauseButtonImage(status)
    }
    
    func didTapForward() {
        playerManager.next()
    }
    
    func didTapBackward() {
        playerManager.previous()
    }
    
    func didSlideSlider(_ value: Float) {
        
    }
    
}


extension PlayerPresenter: PlayerDataSource {
    
    var songName: String? {
        let track = self.tracks[self.currentTrack]
        return track.name
    }
    
    var subTitle: String? {
        let track = self.tracks[self.currentTrack]
        return track.artists.first?.name
    }
    
    var imageUrl: URL? {
        let track = self.tracks[self.currentTrack]
        return URL(string: track.album?.images.first?.url ?? "")
    }
    
    
}

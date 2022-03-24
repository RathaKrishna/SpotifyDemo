//
//  PlaybackPresenter.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/23.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subTitle: String? { get }
    var imageUrl: URL? { get }
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
//    var index = 0
    
    var currentTrack: AudioTrack? {
        if let track = track , tracks.isEmpty {
            return track
        }
        else if let player = self.queuePlayer, !tracks.isEmpty {
            let item = player.currentItem
            let items = player.items()
            guard let index = items.firstIndex(where: { $0 == item }) else {
                return nil
            }
            return tracks[index]
        }
        
        return nil
    }
    var playerVc: PlayerViewController?
    var player: AVPlayer?
    var queuePlayer: AVQueuePlayer?
    
    //play single audio
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack) {
            guard let url = URL(string: track.preview_url ?? "") else {
                return
            }
            player = AVPlayer(url: url)
            player?.volume = 0.3
            self.tracks = []
            self.track = track
            let vc = PlayerViewController()
            vc.title = track.name
            vc.dataSource = self
            vc.delegate = self
            viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
                self?.player?.play()
            }
            self.playerVc = vc
        }
    // play entire tracks
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]) {
            
            self.tracks = tracks
            self.track = nil
            let item: [AVPlayerItem] = tracks.compactMap({
                guard let url = URL(string: $0.preview_url ?? "") else
                {
                    return nil
                }
               return AVPlayerItem(url: url)
            })
            self.queuePlayer = AVQueuePlayer(items: item)
            self.queuePlayer?.volume = 0.3
            self.queuePlayer?.play()
            let vc = PlayerViewController()
            vc.dataSource = self
            vc.delegate = self
            viewController.present(UINavigationController(rootViewController: vc), animated: true)
            self.playerVc = vc
        }
    func didSlideSlider(_ value: Float) {
        player?.volume = value
        
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        else if let player = queuePlayer {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    func didTapForward() {
        if tracks.isEmpty {
            // No playlist
            player?.pause()
        }
        else if let player = queuePlayer{
            queuePlayer?.advanceToNextItem()
//            index += 1
            playerVc?.refreshUI()
        }
    }
    func didTapBackward() {
        if tracks.isEmpty {
            // No playlist
            player?.pause()
            player?.play()
        }
        else if let firstItem  = queuePlayer?.items().first{
            queuePlayer?.pause()
            queuePlayer?.removeAllItems()
            queuePlayer = AVQueuePlayer(items: [firstItem])
            queuePlayer?.play()
            queuePlayer?.volume = 0.3
        }
    }
}
extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subTitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageUrl: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
    
}

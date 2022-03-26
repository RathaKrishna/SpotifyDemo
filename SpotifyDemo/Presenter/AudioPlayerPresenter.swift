//
//  AudioPlayerPresenter.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/26.
//

import Foundation
import UIKit

final class AudioPlayerPresenter {
    
    static let shared = AudioPlayerPresenter()
    
    private var tracks = [AudioTrack]()

    // play entire tracks
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]) {
            
            self.tracks = tracks
            print("tracks size \(self.tracks.count)")
            let vc = AudioPlayerViewController(tracks: self.tracks)
            viewController.present(UINavigationController(rootViewController: vc), animated: true)
        }
}

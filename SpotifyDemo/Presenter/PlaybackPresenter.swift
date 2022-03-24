//
//  PlaybackPresenter.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/23.
//

import Foundation
import UIKit

final class PlaybackPresenter {
    
    //play single audio
    static func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack) {
            let vc = PlayerViewController()
            vc.title = track.name
            viewController.present(UINavigationController(rootViewController: vc), animated: true)
        }
    // play entire tracks
    static func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]) {
            let vc = PlayerViewController()
            viewController.present(UINavigationController(rootViewController: vc), animated: true)
        }
  
}

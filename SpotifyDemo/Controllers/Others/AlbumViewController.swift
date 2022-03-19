//
//  AlbumViewController.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/17.
//

import UIKit

class AlbumViewController: UIViewController {

    private let album: Album
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        title = album.name
        view.backgroundColor = .systemBackground
        fetchData()
    }

    private func fetchData() {
        APICaller.shared.getAlbumDetails(for: self.album) { result in
            DispatchQueue.main.async {
                
            }
        }
    }

}

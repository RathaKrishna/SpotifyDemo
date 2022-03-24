//
//  LibraryToggleView.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/24.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylist(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}
class LibraryToggleView: UIView {

    // enum for button state
    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    weak var delegate: LibraryToggleViewDelegate?
    
    // MARK: - Create views
    private let playlistButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlist", for: .normal)
        return button
    }()
    private let albumButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Album", for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistButton)
        addSubview(albumButton)
        addSubview(indicatorView)
        
        playlistButton.addTarget(self, action: #selector(didTapPlaylist), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Button actions
    @objc func didTapPlaylist() {
        state = .playlist
        delegate?.libraryToggleViewDidTapPlaylist(self)
    }
    
    @objc func didTapAlbums() {
        state = .album
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
    
    // MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playlistButton.snp.makeConstraints { make in
            make.left.top.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        albumButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(playlistButton.snp.right).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        layoutIndicator()
    }
    
    private func layoutIndicator() {
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(x: 10, y: playlistButton.bottom, width: 100, height: 3)
        case .album:
            indicatorView.frame = CGRect(x: 120, y: playlistButton.bottom, width: 100, height: 3)

        }
    }
    
    // upate underline based on button state
    func update(for state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}

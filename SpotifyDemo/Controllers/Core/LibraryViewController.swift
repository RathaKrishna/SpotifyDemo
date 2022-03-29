//
//  LibraryViewController.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/10.
//

import UIKit

class LibraryViewController: UIViewController {

    private let playlistVc = LibraryPlaylistViewController()
    private let albumVc = LibraryAlbumViewController()
    private let toggleView = LibraryToggleView()
    
    private let scrollView: UIScrollView =  {
       let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        toggleView.delegate = self
        view.addSubview(toggleView)
        scrollView.delegate = self
        scrollView.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.width*2, height: scrollView.height)
       
        addChildren()
        updateBarButtons()
    }
    
    private func updateBarButtons() {
        switch toggleView.state {
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    @objc private func didTapAdd() {
        playlistVc.createPlaylist()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.width, height: view.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55)
        toggleView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaInsets.top)
            make.height.equalTo(60)
        }
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(toggleView.snp.bottom)
            make.bottom.equalTo(view.safeAreaInsets)
        }
        

    }

    private func addChildren() {
        addChild(playlistVc)
        scrollView.addSubview(playlistVc.view)
        playlistVc.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistVc.didMove(toParent: self)
        
        addChild(albumVc)
        scrollView.addSubview(albumVc.view)
        albumVc.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumVc.didMove(toParent: self)
    }
}

extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateBarButtons()
        if scrollView.contentOffset.x >= (view.width-100) {
            toggleView.update(for: .album)
        }
        else {
            toggleView.update(for: .playlist)
        }
    }
}

extension LibraryViewController: LibraryToggleViewDelegate {
    func libraryToggleViewDidTapPlaylist(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
//        updateBarButtons()
    }
    
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
//        updateBarButtons()
    }
    
    
}

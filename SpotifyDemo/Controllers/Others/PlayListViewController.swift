//
//  PlayListViewController.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/10.
//

import UIKit

class PlayListViewController: UIViewController {

    private let playlist: Playlist
    
    public var isOwner = false
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ ->NSCollectionLayoutSection? in
        
        // Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 1,
            leading: 2, bottom: 1, trailing: 2)
        // Vertical group in horisontal group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)),
            subitem: item,
            count: 1)
        
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
    }))

    init(playlist: Playlist) {

        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private var viewModels = [RecommendedTrackCellViewModel]()
    private var tracks = [AudioTrack]()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = playlist.name
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(
            PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureNavBar()
        fetchData()
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
   
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer ) {
        guard gesture.state == .began else {
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        let trackToDelete = tracks[indexPath.row]
        let actionSheet = UIAlertController(title: trackToDelete.name, message: "Would you like to remove this from playlist", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            APICaller.shared.removeTrackFromPlaylist(track: trackToDelete, playlist: strongSelf.playlist) { success in
                DispatchQueue.main.async {
                    if success {
                        HapticManager.shared.vibrate(for: .success)
                        strongSelf.tracks.remove(at: indexPath.row)
                        strongSelf.viewModels.remove(at: indexPath.row)
                        strongSelf.collectionView.reloadData()
                    } else {
                        HapticManager.shared.vibrate(for: .error)
                        print("couldn't remove")
                    }
                }
            }
        }))
        present(actionSheet, animated: true)
    }
    @objc func didTapShare() {
        //Share
        guard let url = URL(string: playlist.external_urls["spotify"] ??  "") else {
            return
        }
        let vc = UIActivityViewController(activityItems: ["Check out this cook playlist I found \(url)" ], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
    private func fetchData() {
        APICaller.shared.getPlaylistDetails(for: playlist) {[weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.tracks = model.tracks.items.compactMap({ $0.track })
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendedTrackCellViewModel(name: $0.track.name, artistName: $0.track.artists.first?.name ?? "-", artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
                    })
                    self?.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    

}

extension PlayListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .red
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as? PlaylistHeaderCollectionReusableView , kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderCollectionViewModel(name: playlist.name, ownerName: playlist.owner.display_name, description: playlist.description, artWorkUrl: URL(string: playlist.images.first?.url ?? ""))
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let track = tracks[indexPath.row]
       
//        PlaybackPresenter.shared.startPlayback(from: self, track: track)
        AudioPlayerPresenter.shared.startPlayback(from: self, tracks: [track])
    }
    
    
}

extension PlayListViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        //Start play list in queue
//        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
        AudioPlayerPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
}

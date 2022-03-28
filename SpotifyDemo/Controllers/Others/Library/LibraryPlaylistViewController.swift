//
//  LibraryPlaylistViewController.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/24.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {

    public var selectionHandler: ((Playlist) -> Void)?
    private var playlists = [Playlist]()
    private let noDatView = NoDataView()
    
    private let tableView: UITableView  = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(noDatView)
        view.addSubview(tableView)
        
        noDatView.delegate = self
       
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PlaylistsTableViewCell.self, forCellReuseIdentifier: PlaylistsTableViewCell.identifier)
        updatUI()
        fetchData()
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didCloseTaped))
        }
    }

    @objc func didCloseTaped() {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noDatView.frame = view.bounds
        tableView.frame = view.bounds
    }
    private func fetchData(){
        APICaller.shared.getCurrentUserPlalists {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updatUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updatUI() {
        if playlists.isEmpty {
            //show Label
            noDatView.configure(with: NoDataViewViewModel(text: "No Playlists Found", actionTitle: "Create", imageName: "no_data"))
            noDatView.isHidden = false
            tableView.isHidden = true
        }
        else {
            
            //show table
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    public func createPlaylist() {
        
        let alert = UIAlertController(title: "New Playlist", message: "Enter playlist name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            APICaller.shared.createPlaylist(with: text) {[weak self] success in
                if success{
                    HapticManager.shared.vibrate(for: .success)
                    //refresh the playlist
                    self?.fetchData()
                }
                else {
                    HapticManager.shared.vibrate(for: .error)
                    print("Failed to create playlist")
                }
            }
        }))
        present(alert,animated: true)
        
    }
}

extension LibraryPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistsTableViewCell.identifier, for: indexPath) as? PlaylistsTableViewCell else {
            return UITableViewCell()
        }
        let model = playlists[indexPath.row]
        cell.configure(with: PlaylistsTableViewCellViewModel(imgUrl: URL(string: model.images.first?.url ?? ""), name: model.name))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let playlist = playlists[indexPath.row]
        
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let vc = PlayListViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LibraryPlaylistViewController: NoDataViewDelegate {
    func noDataViewButtonTapped(_ noDataView: NoDataView) {
        self.createPlaylist()
    }
}

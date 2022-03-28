//
//  LibraryAlbumViewController.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/24.
//

import UIKit

class LibraryAlbumViewController: UIViewController {

    private var albums = [AlbumItems]()
    private let noDatView = NoDataView()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        return refreshControl
    }()
    private let tableView: UITableView  = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(noDatView)
        view.addSubview(tableView)
        
        
        noDatView.delegate = self
       
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchResultsDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultsDefaultTableViewCell.identifier)
        
        refreshControl.addTarget(self, action: #selector(doRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        updatUI()
        fetchData()
        observer = NotificationCenter.default.addObserver(forName: .albumSavedNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.fetchData()
        })
        
    }

    @objc func doRefresh(_ sender: UIRefreshControl) {
        fetchData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noDatView.frame = view.bounds
        tableView.frame = view.bounds
    }
    private func fetchData(){
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbum {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.refreshControl.endRefreshing()
                    self?.updatUI()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func updatUI() {
        if albums.isEmpty {
            //show Label
            noDatView.configure(with: NoDataViewViewModel(text: "You haven't save any albums yet", actionTitle: "Browse", imageName: "no_data"))
            noDatView.isHidden = false
            tableView.isHidden = true
        }
        else {
            
            //show table
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
}

extension LibraryAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsDefaultTableViewCell.identifier, for: indexPath) as? SearchResultsDefaultTableViewCell else {
            return UITableViewCell()
        }
        let model = albums[indexPath.row]
        cell.configure(with: SearchResultsDefaultCellViewModel(title: model.album.name, imageUrl: URL(string: model.album.images.first?.url ?? ""), subTitle: model.album.artists.first?.name ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = albums[indexPath.row]

        let vc = AlbumViewController(album: model.album )
        vc.navigationItem.largeTitleDisplayMode = .never
//        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LibraryAlbumViewController: NoDataViewDelegate {
    func noDataViewButtonTapped(_ noDataView: NoDataView) {
        tabBarController?.selectedIndex = 0
    }
}

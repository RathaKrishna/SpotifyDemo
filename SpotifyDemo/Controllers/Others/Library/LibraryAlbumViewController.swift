//
//  LibraryAlbumViewController.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/24.
//

import UIKit

class LibraryAlbumViewController: UIViewController {

    private var albums = [Album]()
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
        
        tableView.register(SearchResultsDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultsDefaultTableViewCell.identifier)
        updatUI()
        fetchData()
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noDatView.frame = view.bounds
        tableView.frame = view.bounds
    }
    private func fetchData(){
        APICaller.shared.getCurrentUserAlbum {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updatUI()
                case .failure(let error):
                    print(error.localizedDescription)
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
        cell.configure(with: SearchResultsDefaultCellViewModel(title: model.name, imageUrl: URL(string: model.images.first?.url ?? ""), subTitle: model.artists.first?.name ?? ""))
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
        
        let album = albums[indexPath.row]

        let vc = AlbumViewController(album: album)
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

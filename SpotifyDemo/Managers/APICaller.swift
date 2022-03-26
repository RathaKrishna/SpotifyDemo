//
//  ApiCaller.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/10.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL =  "https://api.spotify.com/v1"
        
        static let profileUrl = baseAPIURL + "/me"
        static let browseNewReleaseUrl = baseAPIURL + "/browse/new-releases?limit=50"
        static let featurePlaylistUrl = baseAPIURL + "/browse/featured-playlists?limit=50"
        static let recommendationsGenreUrl = baseAPIURL + "/recommendations/available-genre-seeds"
        static let recommendationsUrl = baseAPIURL + "/recommendations?limit=40"
        static let albumDetailsUrl = baseAPIURL + "/albums/"
        static let myPlaylistUrl = baseAPIURL + "/me/playlists"
        static let playlistDetailsUrl = baseAPIURL + "/playlists/"
        static let categoryUrl = baseAPIURL + "/browse/categories"
        static let searchUrl = baseAPIURL + "/search?type=album,artist,playlist,track&include_external=audio&limit=10"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    // MARK: - User profile
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.profileUrl), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
                
            }
            task.resume()
        }
    }
    // MARK: - Get New release
    public func getNewReleases(completion: @escaping ((Result<NewReleasesModel, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.browseNewReleaseUrl), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleasesModel.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
            
        }
    }
    
    // MARK: - Featured Playlist
    public func getFeaturedPlaylist(completion: @escaping ((Result<FeaturedPlaylistModel, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.featurePlaylistUrl), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    
                    let result = try JSONDecoder().decode(FeaturedPlaylistModel.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Get Recommedations Genre
    public func getRecommedationGenre(completion: @escaping ((Result<RecommendedGenreModel, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.recommendationsGenreUrl), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenreModel.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    // MARK: - Recommendations
    
    public func getRecommendations(genres: Set<String>,completion: @escaping ((Result<RecommendationsModel, Error>)) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.recommendationsUrl + "&seed_genres=\(seeds)"), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendationsModel.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Albums
    public func getAlbumDetails(for album: Album,  completion: @escaping ((Result<AlbumDetailsModel, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.albumDetailsUrl + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsModel.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Playlist
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping ((Result<PlaylistDeailsModel,Error>)) -> Void) {
        createRequest(with: URL(string: Constants.playlistDetailsUrl + playlist.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlaylistDeailsModel.self, from: data)
                    completion(.success(result))

                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - edit Playlist
    public func getCurrentUserPlalists(completion: @escaping (Result<[Playlist],Error>) -> Void) {
        createRequest(with: URL(string: Constants.myPlaylistUrl), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlayListResponse.self, from: data)
                    completion(.success(result.items))
                    
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    public func createPlaylist(with name: String, completion: @escaping (Bool) -> Void) {
        
        getCurrentUserProfile {[weak self] result in
            switch result {
            case .success(let profile):
                let urlString = Constants.baseAPIURL + "/users/\(profile.id)/playlists"
                
                self?.createRequest(with: URL(string: urlString), type: .POST) { baseRequest in
                    var request = baseRequest
                    let reqJson = [
                        "name": name
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: reqJson, options: .fragmentsAllowed)
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data = data, error == nil else {
                            completion(false)
                            return
                        }
                        
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                            if let response = result as? [String: Any], response["id"] as? String != nil {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        }
                        catch {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                    task.resume()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    public func addTrackToPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void) {
        
        createRequest(with: URL(string:  Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"), type: .POST) { baseRequest in
            var request = baseRequest
            let json = [
                "uris": ["spotify:track:\(track.id)"]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    if let response = result as? [String: Any],
                       response["snapshot_id"] as? String != nil {
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                }
                catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            }
            task.resume()
        }
        
    }
    public func removeTrackFromPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void) {
        
    }
    
    // MARK: - Categories
    public func getCatogries(completion: @escaping ((Result<[Category], Error>)) -> Void) {
        createRequest(with: URL(string: Constants.categoryUrl + "?country=us&limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(CategoriesModel.self, from: data)
                    completion(.success(result.categories.items))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - singe Category
    
    public func getCategoryPlaylist(category: Category, completion: @escaping ((Result<[Playlist], Error>)) -> Void) {
        createRequest(with: URL(string: Constants.categoryUrl + "/\(category.id)/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    
                    let result = try JSONDecoder().decode(FeaturedPlaylistModel.self, from: data)
                    let playlists = result.playlists.items
                    completion(.success(playlists))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Search
    public func search(with query: String, completion: @escaping (Result<[SearchResults], Error>) -> Void) {
        createRequest(with: URL(string: Constants.searchUrl + "&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(SearchResultModel.self, from: data)
                    var searchResult: [SearchResults] = []
                    searchResult.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0)}))
                    searchResult.append(contentsOf: result.albums.items.compactMap({ .album(model: $0)}))
                    searchResult.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0)}))
                    searchResult.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0)}))
                    completion(.success(searchResult))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Http Methods
    enum HTTPMethod: String {
        case GET
        case POST
    }
    // MARK: - Create Requests
    private func createRequest(with url: URL?, type: HTTPMethod,  completion: @escaping (URLRequest) -> Void)  {
        AuthManager.shared.withValidToken { token  in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            //            request.setValue("", forHTTPHeaderField: "")
            //            request.setValue("", forHTTPHeaderField: "")
            //            request.setValue("", forHTTPHeaderField: "")
            completion(request)
        }
        
        
    }
}

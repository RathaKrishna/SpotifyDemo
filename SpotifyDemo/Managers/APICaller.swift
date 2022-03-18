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
        
        static let profileUrl = "/me"
        static let browseNewReleaseUrl = "/browse/new-releases?limit=50"
        static let featurePlaylistUrl = "/browse/featured-playlists?limit=50"
        static let recommendationsGenreUrl = "/recommendations/available-genre-seeds"
        static let recommendationsUrl = "/recommendations?limit=40"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    // MARK: - User profile
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + Constants.profileUrl), type: .GET) { baseRequest in
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
        createRequest(with: URL(string: Constants.baseAPIURL + Constants.browseNewReleaseUrl), type: .GET) { request in
            
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
        createRequest(with: URL(string: Constants.baseAPIURL + Constants.featurePlaylistUrl), type: .GET) { request in
            
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
        createRequest(with: URL(string: Constants.baseAPIURL + Constants.recommendationsGenreUrl), type: .GET) { request in
            
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
        createRequest(with: URL(string: Constants.baseAPIURL + Constants.recommendationsUrl + "&seed_genres=\(seeds)"), type: .GET) { request in
            
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

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
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    
                    print(result)
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
    
    // MARK: - private
    enum HTTPMethod: String {
        case GET
        case POST
    }
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

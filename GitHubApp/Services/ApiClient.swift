//
//  ApiClient.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import Foundation
import UIKit

enum ApiError: Error {
    case serverConnectionError
    case internalServerError
    case decodingError
}

protocol ApiClientProtocol {
    func getRepositoriesModel(searchString: String, searchType: RepoSearchType, completion: @escaping (Swift.Result<[RepoModel], Error>) -> Void)
//    func downloadAvatarImage(url: String, completion: @escaping (Swift.Result<UIImage?, Error>) -> Void)
}

class ApiClient: ApiClientProtocol {
    
    static let shared = ApiClient()
    
    let configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    var dataTask: URLSessionDataTask?
    
    typealias RepoModelsHandler = (Swift.Result<[RepoModel], Error>) -> Void
    
    func getRepositoriesModel(searchString: String, searchType: RepoSearchType, completion: @escaping RepoModelsHandler) {
        guard let urlRequest = try? ApiRouter.getRepos(searchString: searchString, searchType: searchType).asURLRequest() else {
            return
        }
        requestRepositoriesModel(urlRequest: urlRequest, completion: completion)
    }
}

extension ApiClient {
    private func requestRepositoriesModel(urlRequest: URLRequest, completion: @escaping RepoModelsHandler) {
        dataTask?.cancel()
        dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                   print(httpResponse.statusCode)
               }
            if error != nil {
                completion(.failure(ApiError.internalServerError))
            } else {
                do {
                    let repositoryModel = try JSONDecoder().decode(RepositoriesModel.self, from: data!)
                    print(repositoryModel.items.count)
                    let resultItems = repositoryModel.items.map({ item -> RepoModel in
                        guard let url = URL(string: item.owner.avatar_url) else { return item }
                        var newItem = item
                        if let data = try? Data(contentsOf: url) {
                            newItem.avatarImage = UIImage(data: data)
                        }
                        return newItem
                    })
                    completion(.success(resultItems))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }
        dataTask?.resume()
    }
}

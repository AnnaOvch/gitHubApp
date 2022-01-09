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
    typealias RepoModelsHandler = (Result<[RepoModel], Error>) -> Void
    func getRepositoriesModel(searchString: String, searchType: RepoSearchType, completion: @escaping RepoModelsHandler)
}

protocol ApiUserDetailProtocol {
    typealias UserDetailHandler = (Result<RepoOwner, Error>) -> Void
    func getUserDetails(username: String, completion: @escaping UserDetailHandler)
}

protocol ApiRepoDetailProtocol {
    typealias RepoDetailHandler = (Result<RepoModel, Error>) -> Void
    func getRepoDetails(username: String, repoName: String, completion: @escaping RepoDetailHandler)
}

class ApiClient {
    static let shared = ApiClient()
    private init() {}
    
    let configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    var dataTask: URLSessionDataTask?
}

//MARK: - ApiRepoDetailProtocol
extension ApiClient: ApiRepoDetailProtocol {
    func getRepoDetails(username: String, repoName: String, completion: @escaping (Result<RepoModel, Error>) -> Void) {
        guard let urlRequest = try? ApiRouter.getRepoDetails(username: username, repoName: repoName).asURLRequest() else {
            return
        }
        requestRepoDetails(urlRequest: urlRequest, completion: completion)
    }
    
    private func requestRepoDetails(urlRequest: URLRequest, completion: @escaping RepoDetailHandler) {
        dataTask?.cancel()
        dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            if error != nil || data == nil {
                completion(.failure(ApiError.internalServerError))
            } else {
                do {
                    let repoModel = try JSONDecoder().decode(RepoModel.self, from: data!)
                    completion(.success(repoModel))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }
        dataTask?.resume()
    }
}

//MARK: - ApiUserDetailProtocol
extension ApiClient: ApiUserDetailProtocol {
    func getUserDetails(username: String, completion: @escaping (Result<RepoOwner, Error>) -> Void) {
        guard let urlRequest = try? ApiRouter.getUserDetails(username: username).asURLRequest() else {
            return
        }
        requestUserDetails(urlRequest: urlRequest, completion: completion)
    }
    
    private func requestUserDetails(urlRequest: URLRequest, completion: @escaping UserDetailHandler) {
        dataTask?.cancel()
        dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            if error != nil || data == nil {
                completion(.failure(ApiError.internalServerError))
            } else {
                do {
                    var userModel = try JSONDecoder().decode(RepoOwner.self, from: data!)
                    if let url = URL(string: userModel.avatar_url), let data = try? Data(contentsOf: url) {
                        userModel.avatarImage = UIImage(data: data)
                    }
                    completion(.success(userModel))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }
        dataTask?.resume()
    }
}

//MARK: - ApiClientProtocol
extension ApiClient: ApiClientProtocol {
    func getRepositoriesModel(searchString: String, searchType: RepoSearchType, completion: @escaping RepoModelsHandler) {
        guard let urlRequest = try? ApiRouter.getRepos(searchString: searchString, searchType: searchType).asURLRequest() else {
            return
        }
        requestRepositoriesModel(urlRequest: urlRequest, completion: completion)
    }
    
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

//
//  ApiClient.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import Foundation
import UIKit

protocol ApiSearchRepoProtocol {
    typealias RepoModelsHandler = (Result<[RepoModel], Error>) -> Void
    func getRepositoriesModel(page: Int, searchString: String, searchType: RepoSearchType, completion: @escaping RepoModelsHandler)
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
    var searchRateLimit: Int = NetworkConstants.rateLimit
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
            if error != nil || data == nil {
                completion(.failure(RepoDetailApiError.internalServerError))
            } else if let data = data {
                do {
                    let repoModel = try JSONDecoder().decode(RepoModel.self, from: data)
                    completion(.success(repoModel))
                } catch {
                    completion(.failure(RepoDetailApiError.decodingError))
                }
            } else {
                completion(.failure(RepoDetailApiError.unknownError))
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
            if error != nil || data == nil {
                completion(.failure(UserDetailApiError.internalServerError))
            } else if let data = data {
                do {
                    var userModel = try JSONDecoder().decode(RepoOwner.self, from: data)
                    if let url = URL(string: userModel.avatarURL), let data = try? Data(contentsOf: url) {
                        userModel.avatarImage = UIImage(data: data)
                    }
                    completion(.success(userModel))
                } catch {
                    completion(.failure(UserDetailApiError.decodingError))
                }
            } else {
                completion(.failure(UserDetailApiError.unknownError))
            }
        }
        dataTask?.resume()
    }
}

//MARK: - ApiClientProtocol
extension ApiClient: ApiSearchRepoProtocol {
    func getRepositoriesModel(page: Int, searchString: String, searchType: RepoSearchType, completion: @escaping RepoModelsHandler) {
        guard let urlRequest = try? ApiRouter.getRepos(page: page, searchString: searchString, searchType: searchType).asURLRequest() else {
            return
        }
        requestRepositoriesModel(urlRequest: urlRequest, completion: completion)
    }
    
    private func requestRepositoriesModel(urlRequest: URLRequest, completion: @escaping RepoModelsHandler) {
        dataTask?.cancel()
        dataTask = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            let httpResponse = response as? HTTPURLResponse
            if error != nil {
                completion(.failure(SearchApiError.internalServerError))
            } else if httpResponse?.statusCode == StatusCode.success.rawValue, let data = data {
                self?.updateRateLimit(from: httpResponse)
                do {
                    let repositoryModel = try JSONDecoder().decode(RepositoriesModel.self, from: data)
                    let resultItems = self?.retrieveImages(from: repositoryModel)
                    completion(.success(resultItems ?? []))
                } catch {
                    completion(.failure(SearchApiError.decodingError))
                }
            } else if self?.searchRateLimit == 0, httpResponse?.statusCode == StatusCode.invalidRateLimit.rawValue {
                completion(.failure(SearchApiError.rateLimitExceed))
            } else {
                completion(.failure(SearchApiError.unknownError))
            }
        }
        dataTask?.resume()
    }
    
    private func updateRateLimit(from response: HTTPURLResponse?) {
        if let rateLimitResponse = response?.allHeaderFields["x-ratelimit-remaining"] as? String, let rateLimit = Int(rateLimitResponse) {
            searchRateLimit = rateLimit
        }
    }
    
    private func retrieveImages(from repoModel: RepositoriesModel) -> [RepoModel] {
        return repoModel.repos.map {item -> RepoModel in
            guard let url = URL(string: item.owner.avatarURL) else { return item }
            var newItem = item
            if let data = try? Data(contentsOf: url) {
                newItem.avatarImage = UIImage(data: data)
            }
            return newItem
        }
    }
}

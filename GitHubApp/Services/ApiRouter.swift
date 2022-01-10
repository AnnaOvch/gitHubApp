//
//  ApiRouter.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import Foundation
import Alamofire

enum ApiRouterError: Error {
    case queryErrors
}

enum ApiRouter: URLRequestConvertible {
    case getRepos(page: Int, searchString: String, searchType: RepoSearchType = .usual)
    case getUserDetails(username: String)
    case getRepoDetails(username: String, repoName: String)
    
    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(string: NetworkConstants.baseUrl + path)!
        urlComponents.queryItems = queryItems
        
        guard let url = try urlComponents.url?.asURL() else {
            throw ApiRouterError.queryErrors
        }

        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        
        httpHeaders.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return try JSONEncoding.default.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpHeader
    private var httpHeaders: [String:String] {
        switch self {
        case .getRepos, .getUserDetails, .getRepoDetails:
            return [NetworkConstants.HttpHeaderField.acceptType.rawValue.lowercased(): NetworkConstants.ContentType.jsonGitHub.rawValue]
        }
    }
    
    //MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .getRepos, .getUserDetails, .getRepoDetails:
            return .get
        }
    }
    
    //MARK: - Path
    private var path: String {
        switch self {
        case .getRepos:
            return "search/repositories"
        case .getUserDetails(let username):
            return "users/\(username)"
        case let .getRepoDetails(username, reponame):
            return "repos/\(username)/\(reponame)"
        }
    }
    
    private var queryItems: [URLQueryItem]? {
        switch self {
        case let .getRepos(page, searchString, searchType):
            return makeRepoQueryItems(page: page, searchString: searchString, searchType: searchType)
        case .getUserDetails, .getRepoDetails:
            return nil
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .getRepos, .getUserDetails, .getRepoDetails:
            return nil
        }
    }
}

private extension ApiRouter {
    func makeRepoQueryItems(page: Int, searchString: String, searchType: RepoSearchType) -> [URLQueryItem] {
        switch searchType {
        case .forks:
            return [URLQueryItem(name: "q", value: searchString), URLQueryItem(name: "sort", value: "forks"), URLQueryItem(name: "per_page", value: Constants.countPerPage)]
        case .starts:
            return [URLQueryItem(name: "q", value: searchString), URLQueryItem(name: "sort", value: "stars"), URLQueryItem(name: "per_page", value: Constants.countPerPage)]
        case .updates:
            return [URLQueryItem(name: "q", value: searchString), URLQueryItem(name: "sort", value: "updated"), URLQueryItem(name: "per_page", value: Constants.countPerPage)]
        case .usual:
            return [URLQueryItem(name: "q", value: searchString), URLQueryItem(name: "per_page", value: Constants.countPerPage), URLQueryItem(name: "page", value: String(page))]
        }
    }
}

fileprivate enum Constants {
    static let countPerPage: String = "30"
}

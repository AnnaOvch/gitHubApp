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
    
    case getRepos(searchString: String, searchType: RepoSearchType = .usual)
    
    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(string: NetworkConstants.baseUrl + path)!
        urlComponents.queryItems = queryItems
        
        guard let url = try urlComponents.url?.asURL() else {
            throw  ApiRouterError.queryErrors
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue(NetworkConstants.ContentType.jsonGitHub.rawValue, forHTTPHeaderField: NetworkConstants.HttpHeaderField.acceptType.rawValue.lowercased())
        urlRequest.setValue(NetworkConstants.ContentType.request.rawValue, forHTTPHeaderField: NetworkConstants.HttpHeaderField.userAgent.rawValue)
        
        return try JSONEncoding.default.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .getRepos:
            return .get
        }
    }
    
    //MARK: - Path
    private var path: String {
        switch self {
        case .getRepos:
            return "repositories"
        }
    }
    
    private var queryItems: [URLQueryItem]? {
        switch self {
        case let .getRepos(searchString, searchType):
           return makeQueryItems(searchString: searchString, searchType: searchType)
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .getRepos:
            return nil
        }
    }
}

private extension ApiRouter {
    func makeQueryItems(searchString: String, searchType: RepoSearchType) -> [URLQueryItem] {
        switch searchType {
        case .forks:
            return [URLQueryItem(name: "q", value: searchString), URLQueryItem(name: "sort", value: "forks")]
        case .starts:
            return [URLQueryItem(name: "q", value: searchString), URLQueryItem(name: "sort", value: "stars")]
        case .updates:
            return [URLQueryItem(name: "q", value: searchString), URLQueryItem(name: "sort", value: "updated")]
        case .usual:
            return [URLQueryItem(name: "q", value: searchString), URLQueryItem(name: "per_page", value: "100")]
        }
    }
}

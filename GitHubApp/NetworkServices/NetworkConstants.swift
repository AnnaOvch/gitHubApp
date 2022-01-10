//
//  NetworkConstants.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import Foundation

struct NetworkConstants {
    static let baseUrl = "https://api.github.com/"
    static let rateLimit = 10
    
    enum HttpHeaderField: String {
        case acceptType = "accept"
    }

    enum ContentType: String {
        case jsonGitHub = "application/vnd.github.v3+json"
    }
}

enum StatusCode: Int {
    case success = 200
    case invalidRateLimit = 403
}

//
//  NetworkConstants.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import Foundation

struct NetworkConstants {
    static let baseUrl = "https://api.github.com/search/"
    
    enum HttpHeaderField: String {
        case acceptType = "accept"
        case userAgent = "User-Agent"
    }

    enum ContentType: String {
        case jsonGitHub = "application/vnd.github.v3+json"
        case request = "request"
    }
}

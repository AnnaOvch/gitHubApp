//
//  ApiError.swift
//  GitHubApp
//
//  Created by Анна on 10.01.2022.
//

import Foundation

enum SearchApiError: Error {
    case unknownError
    case internalServerError
    case decodingError
    case rateLimitExceed
}

extension SearchApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknownError:
            return "Unknown Server Error"
        case .internalServerError:
            return "Internal Server Error"
        case .decodingError:
            return "Error in decoding models"
        case .rateLimitExceed:
            return "Rate limit exceed, wait 1 minute before search"
        }
    }
}

enum RepoDetailApiError: Error {
    case unknownError
    case internalServerError
    case decodingError
}

extension RepoDetailApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknownError:
            return "Unknown Server Error while fetching repo"
        case .internalServerError:
            return "Internal Server Error while fetching repo"
        case .decodingError:
            return "Error in decoding repo model"
        }
    }
}

enum UserDetailApiError: Error {
    case unknownError
    case internalServerError
    case decodingError
}

extension UserDetailApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknownError:
            return "Unknown Server Error while fetching user"
        case .internalServerError:
            return "Internal Server Error while fetching user"
        case .decodingError:
            return "Error in decoding user model"
        }
    }
}

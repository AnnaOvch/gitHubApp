//
//  ApiError.swift
//  GitHubApp
//
//  Created by Анна on 10.01.2022.
//

import Foundation

enum ApiError: Error {
    case unknownError
    case internalServerError
    case decodingError
    case rateLimitExceed
}

extension ApiError: LocalizedError {
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

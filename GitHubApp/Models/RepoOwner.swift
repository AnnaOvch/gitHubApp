//
//  RepoOwner.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import UIKit

struct RepoOwner: Codable {
    let avatar_url: String
    let login: String
    let id: Int
    
    let public_repos: Int?
    let location: String?
    let html_url: String?
    
    private enum CodingKeys: String, CodingKey {
        case avatar_url
        case login
        case id
        case public_repos
        case location
        case html_url
    }
    
    var avatarImage: UIImage?
}

//
//  RepoOwner.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import UIKit

struct RepoOwner: Codable {
    let avatarURL: String
    let login: String
    let id: Int
    
    let publicReposCount: Int?
    let location: String?
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case login
        case id
        case publicReposCount = "public_repos"
        case location
        case url = "html_url"
    }
    
    var avatarImage: UIImage?
}

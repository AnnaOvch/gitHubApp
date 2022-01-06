//
//  RepoModel.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import UIKit

struct RepoModel: Codable {
    let name: String
    let full_name: String
    let watchers_count: Int
    let forks_count: Int
    let open_issues: Int
    let owner: RepoOwner
    
    private enum CodingKeys: String, CodingKey {
        case name
        case full_name
        case watchers_count
        case forks_count
        case open_issues
        case owner
    }
    
    var avatarImage: UIImage? 
}

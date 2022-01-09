//
//  RepositoriesModel.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import Foundation

struct RepositoriesModel: Decodable {
    let reposCount: Int
    let repos: [RepoModel]
    
    private enum CodingKeys: String, CodingKey {
        case reposCount = "total_count"
        case repos = "items"
    }
}

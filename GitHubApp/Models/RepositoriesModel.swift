//
//  RepositoriesModel.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import Foundation

struct RepositoriesModel: Codable {
    let total_count: Int
    let items: [RepoModel]
}

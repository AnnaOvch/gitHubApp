//
//  RepoModel.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import UIKit

struct RepoModel: Decodable {
    let name: String
    let fullName: String
    let watchersCount: Int
    let forksCount: Int
    let issuesCount: Int
    let owner: RepoOwner
    
    let language: String?
    var creationDate: String?
    var modificationDate: String?
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case issuesCount = "open_issues"
        case owner
        case language
        case creationDate = "created_at"
        case modificationDate = "updated_at"
        case url = "html_url"
    }
    
    var avatarImage: UIImage?
}

extension RepoModel {
    var createdDateString: String {
        guard let created = creationDate, let result = FormatDate.utcToLocal(created) else {
            return Constants.unknown
        }
        return result
    }
    
    var modifiedDateString: String {
        guard let modified = modificationDate, let result =  FormatDate.utcToLocal(modified) else {
            return Constants.unknown
        }
        return result
    }
}

fileprivate enum Constants {
    static let unknown: String = "Unknown"
}

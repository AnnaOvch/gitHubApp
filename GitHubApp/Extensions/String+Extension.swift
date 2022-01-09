//
//  String+Extension.swift
//  GitHubApp
//
//  Created by Анна on 08.01.2022.
//

import Foundation

struct FormatDate {
    static func utcToLocal(_ str: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        guard let date = dateFormatter.date(from: str) else { return nil }
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}


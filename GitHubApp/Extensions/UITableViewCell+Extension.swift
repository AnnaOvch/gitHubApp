//
//  UITableViewCell+Extension.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import UIKit
extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            return nil
        }
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
}

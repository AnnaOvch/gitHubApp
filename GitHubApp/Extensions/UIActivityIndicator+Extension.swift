//
//  UIActivityIndicator+Extension.swift
//  GitHubApp
//
//  Created by Анна on 07.01.2022.
//

import UIKit
extension UIActivityIndicatorView {
    func start() {
        startAnimating()
    }
    
    func stop() {
        stopAnimating()
        hidesWhenStopped = true
    }
}


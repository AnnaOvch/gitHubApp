//
//  UIActivityIndicator+Extension.swift
//  GitHubApp
//
//  Created by Анна on 07.01.2022.
//

import UIKit
extension UIActivityIndicatorView {
    func stop() {
        stopAnimating()
        hidesWhenStopped = true
    }
    
    func start() {
        self.startAnimating()
    }
}



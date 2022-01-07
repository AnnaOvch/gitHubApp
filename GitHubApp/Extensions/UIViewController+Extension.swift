//
//  UIViewController+Extension.swift
//  GitHubApp
//
//  Created by Анна on 07.01.2022.
//

import UIKit

extension UIViewController {
   func showDefaultAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

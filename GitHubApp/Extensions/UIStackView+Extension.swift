//
//  UIStackView+Extension.swift
//  GitHubApp
//
//  Created by Анна on 08.01.2022.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}

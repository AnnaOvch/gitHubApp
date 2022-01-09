//
//  CoordinatorProtocol.swift
//  GitHubApp
//
//  Created by Анна on 08.01.2022.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

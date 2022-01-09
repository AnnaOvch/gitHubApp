//
//  MainCoordinator.swift
//  GitHubApp
//
//  Created by Анна on 08.01.2022.
//

import UIKit

protocol MainCoordinatorProtocol: Coordinator {
    func pushUserDetails(username: String)
    func openUserDetailsInBrowser(by url: URL)
    func pushRepoDetails(username: String, reponame: String)
    func openRepoDetailsInBrowser(by url: URL)
}

class MainCoordinator: MainCoordinatorProtocol {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mainViewController = ViewController.instantiate()
        let viewModel = MainViewModel(networkService: ApiClient.shared)
        viewModel.coordinator = self
        mainViewController.viewModel = viewModel
        navigationController.pushViewController(mainViewController, animated: false)
    }
    
    func pushRepoDetails(username: String, reponame: String) {
        let repoDetailViewController = RepositoryDetailViewController()
        let viewModel = RepositoryDetailViewModel(username: username,reponame: reponame, networkService: ApiClient.shared)
        viewModel.coordinator = self
        repoDetailViewController.viewModel = viewModel
        navigationController.pushViewController(repoDetailViewController, animated: true)
    }
    
    func openUserDetailsInBrowser(by url: URL) {
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func pushUserDetails(username: String) {
        let userDetailViewController = UserDetailViewController()
        let viewModel = UserDetailViewModel(username: username, networkService: ApiClient.shared)
        viewModel.coordinator = self
        userDetailViewController.viewModel = viewModel
        navigationController.pushViewController(userDetailViewController, animated: true)
    }
    
    func openRepoDetailsInBrowser(by url: URL) {
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

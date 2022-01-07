//
//  MainViewModel.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import UIKit

enum RepoSearchType: Int {
    case usual
    case starts
    case forks
    case updates
}

protocol MainViewModelType {
    var delegate: MainViewModelDelegate? { get set }
    func getRepos() -> [RepoModel]?
    func getRepos(by searchString: String, searchType: RepoSearchType)
    func getRepo(by indexPath: IndexPath) -> RepoModel?
    func getReposCount() -> Int?
    func didSelectRepo(at indexPath: IndexPath)
    func didSelectUser(at indexPath: IndexPath)
}

protocol MainViewModelDelegate: AnyObject {
    func fetchedRepos()
    func pushController(_ controller: UIViewController)
}

class MainViewModel: MainViewModelType {
    weak var delegate: MainViewModelDelegate?
    
    private let networkService: ApiClientProtocol!
    
    private var repos: [RepoModel]?
    
    
    init(networkService: ApiClientProtocol) {
        self.networkService = networkService
    }
    
    func getRepos() -> [RepoModel]? {
        return repos
    }
    
    func getRepos(by searchString: String, searchType: RepoSearchType) {
        guard !searchString.isEmpty else  {
            repos = []
            delegate?.fetchedRepos()
            return
        }
        ApiClient.shared.getRepositoriesModel(searchString: searchString, searchType: searchType) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let models):
                    self?.repos = models
                    self?.delegate?.fetchedRepos()
                   // self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getRepo(by indexPath: IndexPath) -> RepoModel? {
        return repos?[indexPath.row]
    }
    
    func getReposCount() -> Int? {
        return repos?.count
    }
    
    func didSelectRepo(at indexPath: IndexPath) {
        guard let username = repos?[indexPath.row].owner.login, let reponame = repos?[indexPath.row].name else { return }
        let detailRepoController = RepositoryDetailViewController.make(username: username, reponame: reponame)
        delegate?.pushController(detailRepoController)
    }
    
    func didSelectUser(at indexPath: IndexPath) {
        guard let username = repos?[indexPath.row].owner.login else { return }
        let detailUserController = UserDetailViewController.make(for: username)
        delegate?.pushController(detailUserController)
    }
}

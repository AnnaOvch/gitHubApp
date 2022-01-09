//
//  MainViewModel.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import UIKit

protocol MainViewModelType {
    var delegate: MainViewModelDelegate? { get set }
    var isLoadingData: Bool { get }
    var page: Int { get }
    func getRepos() -> [RepoModel]?
    func getRepos(page: Int, by searchString: String, searchType: RepoSearchType)
    func getRepo(by indexPath: IndexPath) -> RepoModel?
    func getReposCount() -> Int?
    func didSelectRepo(at indexPath: IndexPath)
    func didSelectUser(at indexPath: IndexPath)
    func didUpdateUI()
}

extension MainViewModelType {
    func getRepos(by searchString: String, searchType: RepoSearchType) {
        return getRepos(page: 1, by: searchString, searchType: searchType)
    }
}

protocol MainViewModelDelegate: AnyObject {
    func fetchedRepos()
    func fetchedAdditionalRepos()
}

class MainViewModel: MainViewModelType {
    weak var delegate: MainViewModelDelegate?
    
    weak var coordinator: MainCoordinator?
    private let networkService: ApiClientProtocol!
    
    private var repos: [RepoModel]?
    
    //pagination
    private (set) var isLoadingData: Bool  = false
    private (set) var page: Int = 1
    
    
    init(networkService: ApiClientProtocol) {
        self.networkService = networkService
    }
    
    func getRepos() -> [RepoModel]? {
        return repos
    }
    
    func getRepos(page: Int, by searchString: String, searchType: RepoSearchType) {
        isLoadingData = true
        guard !searchString.isEmpty else  {
            repos = []
            delegate?.fetchedRepos()
            return
        }
        ApiClient.shared.getRepositoriesModel(page: page, searchString: searchString, searchType: searchType) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let models):
                    if page > 1 {
                        self?.repos?.append(contentsOf: models)
                        self?.delegate?.fetchedAdditionalRepos()
                    } else {
                        self?.repos = models
                        self?.delegate?.fetchedRepos()
                    }
                    self?.page += 1
                case .failure(let error):
                    print(error.localizedDescription)
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
        coordinator?.pushRepoDetails(username: username, reponame: reponame)
    }
    
    func didSelectUser(at indexPath: IndexPath) {
        guard let username = repos?[indexPath.row].owner.login else { return }
        coordinator?.pushUserDetails(username: username)
    }
    
    func didUpdateUI() {
        isLoadingData = false
    }
}

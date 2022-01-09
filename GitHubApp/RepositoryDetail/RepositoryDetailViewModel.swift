//
//  RepositoryDetailViewModel.swift
//  GitHubApp
//
//  Created by Анна on 08.01.2022.
//

import UIKit

protocol RepositoryDetailViewModelType {
    var delegate: RepositoryDetailViewModelDelegate? { get set }
    func viewDidLoad()
    func didTapOpenDetailsButton()
    func didTapOpenUserDetailsButton()
}

protocol RepositoryDetailViewModelDelegate: AnyObject {
    func loadedRepoDetails(_ model: RepoModel)
    func showActivityIndicator(_ isLoading: Bool)
    func showError(_ message: String)
}

class RepositoryDetailViewModel: RepositoryDetailViewModelType {
    weak var delegate: RepositoryDetailViewModelDelegate?
    weak var coordinator: MainCoordinator?
    private let networkService: ApiRepoDetailProtocol!
    private let username: String!
    private let reponame: String!
    private var repoModel: RepoModel?
    
    init(username: String, reponame: String, networkService: ApiRepoDetailProtocol) {
        self.networkService = networkService
        self.username = username
        self.reponame = reponame
    }
    
    func viewDidLoad() {
        delegate?.showActivityIndicator(true)
        networkService.getRepoDetails(username: username, repoName: reponame) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let repoModel):
                    var resultRepoModel = repoModel
                    resultRepoModel.updated_at = repoModel.modifiedDateString ?? Constants.unknown
                    resultRepoModel.created_at = repoModel.createdDateString  ?? Constants.unknown
                    self?.repoModel = resultRepoModel
                    self?.delegate?.loadedRepoDetails(resultRepoModel)
                case .failure(let error):
                    self?.delegate?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func didTapOpenDetailsButton() {
        guard let repoModel = repoModel, let repoURL = repoModel.html_url, let url = URL(string: repoURL) else {
             return
        }
        coordinator?.openRepoDetailsInBrowser(by: url)
    }
    
    func didTapOpenUserDetailsButton() {
        guard let username = repoModel?.owner.login else {
             return
        }
        coordinator?.pushUserDetails(username: username)
    }
}

fileprivate enum Constants {
    static let unknown: String = "Unknown"
}

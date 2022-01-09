//
//  UserViewModel.swift
//  GitHubApp
//
//  Created by Анна on 07.01.2022.
//

import UIKit

protocol UserDetailViewModelType {
    var delegate: UserDetailViewModelDelegate? { get set }
    func viewDidLoad()
    func didTapOpenDetailsButton()
}

protocol UserDetailViewModelDelegate: AnyObject {
    func loadedUserDetails(_ model: RepoOwner)
    func showActivityIndicator(_ isLoading: Bool)
    func showError(_ message: String)
}

class UserDetailViewModel: UserDetailViewModelType {
    weak var delegate: UserDetailViewModelDelegate?
    weak var coordinator: MainCoordinator?
    private let networkService: ApiUserDetailProtocol!
    private let username: String!
    private var userModel: RepoOwner?
    
    init(username: String, networkService: ApiUserDetailProtocol) {
        self.networkService = networkService
        self.username = username
    }
    
    func viewDidLoad() {
        delegate?.showActivityIndicator(true)
        networkService.getUserDetails(username: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.userModel = user
                    self?.delegate?.loadedUserDetails(user)
                case .failure(let error):
                    self?.delegate?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func didTapOpenDetailsButton() {
        guard let userModel = userModel, let userURL = userModel.url, let url = URL(string: userURL) else {
             return
        }
        coordinator?.openUserDetailsInBrowser(by: url)
    }
}

//
//  RepositoryDetailViewController.swift
//  GitHubApp
//
//  Created by Анна on 08.01.2022.
//

import UIKit

extension RepositoryDetailViewController {
    static func make(username: String, reponame: String) -> RepositoryDetailViewController {
        let repoDetailViewController = RepositoryDetailViewController()
        repoDetailViewController.viewModel = RepositoryDetailViewModel(username: username,reponame: reponame, networkService: ApiClient.shared)
        return repoDetailViewController
    }
}

class RepositoryDetailViewController: UIViewController {
    var viewModel: RepositoryDetailViewModelType!
    
    private lazy var detailsStackView: UIStackView = {
        let detailsStackView = UIStackView()
        detailsStackView.axis = .vertical
        detailsStackView.spacing = Constants.detailsStackSpacing
        detailsStackView.distribution = .fillProportionally
        detailsStackView.alignment = .center
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailsStackView)
        detailsStackView.addArrangedSubviews([programmingLangageLabel,
                                              dateOfCreationLabel,
                                              dateOfModificationLabel,
                                              openDetailsButton
        ])
        return detailsStackView
    }()
    
    private lazy var programmingLangageLabel: UILabel = {
        let programmingLangageLabel = UILabel()
        return programmingLangageLabel
    }()
    
    private lazy var dateOfCreationLabel: UILabel = {
        let dateOfCreationLabel = UILabel()
        return dateOfCreationLabel
    }()
    
    private lazy var dateOfModificationLabel: UILabel = {
        let dateOfModificationLabel = UILabel()
        return dateOfModificationLabel
    }()
    
    private lazy var openDetailsButton: UIButton = {
        let openDetailsButton = UIButton()
        openDetailsButton.setTitle(Constants.buttonTitle, for: .normal)
        openDetailsButton.addTarget(self, action: #selector(didTapOpenDetailsButton), for: .touchUpInside)
        return openDetailsButton
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegates()
        setUpUI()
        setUpConstraints()
        
        viewModel.viewDidLoad()
    }
}

//MARK: - Private Methods
private extension RepositoryDetailViewController {
    func setUpUI() {
        view.backgroundColor = .yellow
        title = Constants.title
    }
    
    func setUpDelegates() {
       viewModel.delegate = self
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.detailsStackTop),
            detailsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.detailsStackLeading),
            detailsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.detailsStackTrailing)
        ])
    }
    
    @objc func didTapOpenDetailsButton() {
        viewModel.didTapOpenDetailsButton()
    }
}

//MARK: - RepositoryDetailViewModelDelegate
extension RepositoryDetailViewController: RepositoryDetailViewModelDelegate {
    func showActivityIndicator(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func loadedRepoDetails(_ model: RepoModel) {
        showActivityIndicator(false)
        programmingLangageLabel.text =  Constants.languageTitle + (model.language ?? Constants.unknown)
        dateOfCreationLabel.text = Constants.createdAtTitle + (model.created_at ?? Constants.unknown)
        dateOfModificationLabel.text = Constants.modifiedAtTitle + (model.updated_at ?? Constants.unknown)
    }
    
    func showError(_ message: String) {
        showActivityIndicator(false)
        showDefaultAlert(withTitle: Constants.errorTitle, message: message)
    }
}

fileprivate enum Constants {
    static let errorTitle: String = "Error!"
    static let buttonTitle: String = "Surf Net"
    static let title: String = "Repository"
    
    static let languageTitle: String = "Language: "
    static let createdAtTitle: String = "Created at: "
    static let modifiedAtTitle: String = "Last modified at: "
    static let unknown: String = "Unknown"
    
    static let detailsStackSpacing: CGFloat = 5
    static let detailsStackTop: CGFloat = 20
    static let detailsStackLeading: CGFloat = 10
    static let detailsStackTrailing: CGFloat = -10
}


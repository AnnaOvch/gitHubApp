//
//  UserDetailViewController.swift
//  GitHubApp
//
//  Created by Анна on 07.01.2022.
//

import UIKit

class UserDetailViewController: UIViewController {
    var viewModel: UserDetailViewModelType!
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.masksToBounds = true
        view.addSubview(avatarImageView)
        return avatarImageView
    }()
    
    private lazy var detailsStackView: UIStackView = {
        let detailsStackView = UIStackView()
        detailsStackView.axis = .vertical
        detailsStackView.spacing = Constants.detailsStackSpacing
        detailsStackView.distribution = .fillProportionally
        detailsStackView.alignment = .center
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailsStackView)
        detailsStackView.addArrangedSubviews([loginLabel,
                                              idLabel,
                                              publicRepoLabel,
                                              locationLabel,
                                              openDetailsButton
        ])
        detailsStackView.setCustomSpacing(Constants.buttonSpacing, after: locationLabel)
        return detailsStackView
    }()
    
    private lazy var loginLabel: UILabel = {
        let loginLabel = UILabel()
        return loginLabel
    }()
    
    private lazy var idLabel: UILabel = {
        let idLabel = UILabel()
        return idLabel
    }()
    
    private lazy var publicRepoLabel: UILabel = {
        let publicRepoLabel = UILabel()
        return publicRepoLabel
    }()
    
    private lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        return locationLabel
    }()
    
    private lazy var openDetailsButton: CustomButton = {
        let openDetailsButton = CustomButton()
        openDetailsButton.cornerRadiusDivider = 2
        openDetailsButton.titleText = "Surf Net"
        openDetailsButton.titleColor = .black
        openDetailsButton.borderColor = UIColor.white.cgColor
        openDetailsButton.borderWidth = 3
        openDetailsButton.contentSpacing = 8
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
        setUpUI()
        setUpDelegates()
        setUpConstraints()
        
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / Constants.cornerRadiusDivider
    }
}

private extension UserDetailViewController {
    func setUpUI() {
        view.backgroundColor = UIColor.getCustomBlueColor()
        title = Constants.title
    }
    
    func setUpDelegates() {
        viewModel.delegate = self
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.avatarTop),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.avatarLeading),
            avatarImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.avatarTrailing),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            detailsStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.detailsStackTop),
            detailsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.detailsStackLeading),
            detailsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.detailsStackTrailing)//,
           // detailsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.detailsStackBottom)
        ])
    }
    
    @objc private func didTapOpenDetailsButton() {
        viewModel.didTapOpenDetailsButton()
    }
}

extension UserDetailViewController: UserDetailViewModelDelegate {
    func showActivityIndicator(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func loadedUserDetails(_ model: RepoOwner) {
        showActivityIndicator(false)
        avatarImageView.image = model.avatarImage
        locationLabel.text = "Location: " + (model.location ?? "Unknown")
        idLabel.text = "ID: " + String(model.id)
        loginLabel.text = "Login: " + model.login
        publicRepoLabel.text = "Number of public repos: " + String(model.public_repos ?? 0)
    }
    
    func showError(_ message: String) {
        showActivityIndicator(false)
        showDefaultAlert(withTitle: Constants.errorTitle, message: message)
    }
}

fileprivate enum Constants {
    static let errorTitle: String = "Error!"
    static let title: String = "User"
    
    static let cornerRadiusDivider: CGFloat = 5
    
    static let avatarTop: CGFloat = 30
    static let avatarLeading: CGFloat = 40
    static let avatarTrailing: CGFloat = -40
    
    static let detailsStackSpacing: CGFloat = 8
    static let detailsStackTop: CGFloat = 20
    static let detailsStackLeading: CGFloat = 10
    static let detailsStackTrailing: CGFloat = -10
    
    static let buttonSpacing: CGFloat = 35
}

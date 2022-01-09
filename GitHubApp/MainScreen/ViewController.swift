//
//  ViewController.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import UIKit
import SwiftDebouncer
//extension UIViewController {
//    static func make() -> UIViewController {
//        let viewController = UIViewController()
//        viewController.
//    }
//}

class ViewController: UIViewController, Storyboarded {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let debouncer = Debouncer(delay: 3)
    
    var viewModel: MainViewModelType!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityView.center = self.view.center
        view.addSubview(activityView)
        return activityView
    }()
    
    private lazy var bottomSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        return spinner
    }()
    
    private lazy var spinnerFooterView: UIView = {
        let spinnerFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: Constants.spinnerHeight))
        bottomSpinner.center = spinnerFooterView.center
        spinnerFooterView.addSubview(bottomSpinner)
        return spinnerFooterView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpDelegates()
        setUpTableView()
    }
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        guard let searchText = searchBar.searchTextField.text else { return }
        activityIndicator.startAnimating()
        viewModel.getRepos(by: searchText, searchType: RepoSearchType(rawValue: sender.selectedSegmentIndex) ?? .usual)
    }
}

//MARK: - MainViewModelDelegate
extension ViewController: MainViewModelDelegate {
    func fetchedRepos() {
        tableView.reloadData()
        activityIndicator.stop()
        viewModel.didUpdateUI()
    }
    
    func fetchedAdditionalRepos() {
        tableView.tableFooterView = nil
        tableView.reloadData()
        viewModel.didUpdateUI()
    }
}

//MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY >= tableView.contentSize.height - scrollView.frame.size.height {
            guard !viewModel.isLoadingData, let searchText = searchBar.text else {
                return
            }
            
            tableView.tableFooterView = spinnerFooterView
            bottomSpinner.startAnimating()
            
            viewModel.getRepos(page: viewModel.page, by: searchText, searchType: RepoSearchType(rawValue: segmentedControl.selectedSegmentIndex) ?? .usual)
        }
    }
}

//MARK: - UITableViewDelegate && UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reposCount = viewModel.getReposCount(), reposCount > 1 else {
            tableView.setEmptyMessage(message: Constants.emptyMessage)
            return 0
        }
        return reposCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: RepositoryTableViewCell.self, for: indexPath) as? RepositoryTableViewCell, let repoModel = viewModel.getRepo(by: indexPath)  else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configure(repoModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRepo(at: indexPath)
    }
}

//MARK: - RepositoryTableViewCellDelegate
extension ViewController: RepositoryTableViewCellDelegate {
    func didTapAvatarImage(for indexPath: IndexPath) {
        viewModel.didSelectUser(at: indexPath)
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.hideEmptyMessage()
        if !activityIndicator.isAnimating { activityIndicator.start() }
        debouncer.callback = { [weak self] in
            self?.getRepositories()
        }
        debouncer.call()
    }
    
    @objc func getRepositories() {
        guard let searchText = searchBar.text else {
            return
        }
        activityIndicator.startAnimating()
        viewModel.getRepos(by: searchText, searchType: RepoSearchType(rawValue: segmentedControl.selectedSegmentIndex) ?? .usual)
    }
}

//MARK: - Private Methods
private extension ViewController {
    func setUpUI() {
        title = Constants.navBarTitle
        searchBar.returnKeyType = .done
    }
    
    func setUpDelegates() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
    }
    
    func setUpSearchBar() {
        searchBar.backgroundColor = .clear
    }
    
    func setUpTableView() {
        tableView.backgroundColor = .clear
        tableView.registerCell(type: RepositoryTableViewCell.self, identifier: RepositoryTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
    }
}

//MARK: - Constants
fileprivate enum Constants {
    static let emptyMessage: String = "Please search repos"
    static let navBarTitle: String = "GitHub API"
    
    static let estimatedRowHeight: CGFloat = 44.0
    static let spinnerHeight: CGFloat = 100
}

//
//  ViewController.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import UIKit
//extension UIViewController {
//    static func make() -> UIViewController {
//        let viewController = UIViewController()
//        viewController.
//    }
//}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel: MainViewModelType! = MainViewModel(networkService: ApiClient())
    
    var isPagination = false
    
   // var repos: [RepoModel]?
    
    private lazy var activityIndicator: UIActivityIndicatorView =  {
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityView.center = self.view.center
        view.addSubview(activityView)
        return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegates()
        setUpTableView()
        viewModel.delegate = self
    }
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        guard let searchText = searchBar.searchTextField.text else { return }
        activityIndicator.startAnimating()
        viewModel.getRepos(by: searchText, searchType: RepoSearchType(rawValue: sender.selectedSegmentIndex) ?? .usual)
    }
}

extension ViewController: MainViewModelDelegate {
    func fetchedRepos() {
        tableView.reloadData()
        activityIndicator.stop()
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY >= tableView.contentSize.height - scrollView.frame.size.height {
//            guard !isPaginationOn else {
//                return
//            }
            print("pagination")
            
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
        cell.configure(repoModel)
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.hideEmptyMessage()
        activityIndicator.start()
        perform(#selector(getRepositories), with: nil, afterDelay: 0.3)
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
    func setUpDelegates() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpSearchBar() {
        searchBar.backgroundColor = .clear
    }
    
    func setUpTableView() {
        tableView.backgroundColor = .clear
        tableView.registerCell(type: RepositoryTableViewCell.self, identifier: RepositoryTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }
}

fileprivate enum Constants {
    static let emptyMessage: String = "Please search repos"
}

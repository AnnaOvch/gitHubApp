//
//  RepositoryTableViewCell.swift
//  GitHubApp
//
//  Created by Анна on 06.01.2022.
//

import UIKit

protocol RepositoryTableViewCellDelegate: AnyObject {
    func didTapAvatarImage(for indexPath: IndexPath)
}

class RepositoryTableViewCell: UITableViewCell {
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    weak var delegate: RepositoryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUp()
    }
    
    func configure(_ model: RepoModel) {
        repoNameLabel.text = Constants.repoName + model.name
        authorImageView.image =  model.avatarImage
        authorNameLabel.text = Constants.authorName + model.owner.login
        watchersLabel.text = Constants.numWatchers + String(model.watchers_count)
        forksLabel.text = Constants.numForks + String(model.forks_count)
        issuesLabel.text = Constants.numIssues + String(model.open_issues)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorImageView.image = nil
        repoNameLabel.text = ""
        authorNameLabel.text = ""
        watchersLabel.text = ""
        forksLabel.text = ""
        issuesLabel.text = ""
    }
}

private extension RepositoryTableViewCell {
    func initialSetUp() {
        selectionStyle = .none
        authorImageView.layer.cornerRadius = authorImageView.bounds.height / Constants.cornerRadiusDivider
        authorImageView.layer.masksToBounds = true
        authorImageView.isUserInteractionEnabled = true
        let authorImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAuthorImageView))
        authorImageView.addGestureRecognizer(authorImageViewTapGesture)
    }
    
    @objc func didTapAuthorImageView() {
        guard let indexPath = self.getIndexPath() else { fatalError() }
        delegate?.didTapAvatarImage(for: indexPath)
    }
}

fileprivate enum Constants {
    static let cornerRadiusDivider: CGFloat = 5
//    static let repoName: NSMutableAttributedString = NSMutableAttributedString(string: "Repo Name: ",
//                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)]).append(NSAttributedString(s))
       // "Repo Name: "
    static let repoName = "Repo Name: "
    static let authorName = "Author: "
    static let numWatchers = "Number of watchers: "
    static let numForks = "Number of forks: "
    static let numIssues = "Number of issues: "
}

//
//  RepositorySearchCellModel.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 19/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

class RepositorySearchCellModel {
    let repository: GithubRepository
    var avatar: UIImage? //TODO: need store only thumbnail, not full resolution image
    let keywords: [String]

    init(repository: GithubRepository, keywords: [String]) {
        self.repository = repository
        self.keywords = keywords
    }
    
    static func parse(repositories:[GithubRepository], keywords: [String]) -> [RepositorySearchCellModel] {
        var models = [RepositorySearchCellModel]()
        for repository in repositories {
            models.append(RepositorySearchCellModel(repository: repository, keywords: keywords))
        }
        return models
    }
    
    private lazy var placeholderImage: UIImage = #imageLiteral(resourceName: "user_placeholder")
    func fill(cell: RepositorySearchCell) {
        cell.repositoryView?.titleLabel.setText(repository.name, keywords: self.keywords)//.text = repository.name
        cell.repositoryView?.descriptionLabel.setText(repository.description, keywords: self.keywords)//text = repository.description
        cell.repositoryView?.avatarImageView.image = placeholderImage
        if let avatarImage = avatar {
            cell.repositoryView?.avatarImageView.image = avatarImage
        }
        else {
            DispatchQueue.global(qos: .background).async { [weak self] in
                if let avatarUrlString = self?.repository.owner.avatarUrl, let avatarUrl = URL(string: avatarUrlString) {
                    cell.repositoryView?.avatarImageView.downloadImage(url: avatarUrl, completion: { (image) in
                        self?.avatar = image
                    })
                }
            }
        }
    }
}

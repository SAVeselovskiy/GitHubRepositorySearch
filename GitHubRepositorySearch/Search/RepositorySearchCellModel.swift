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
    
    init(repository: GithubRepository) {
        self.repository = repository
    }
    
    static func parse(repositories:[GithubRepository]) -> [RepositorySearchCellModel] {
        var models = [RepositorySearchCellModel]()
        for repository in repositories {
            models.append(RepositorySearchCellModel(repository: repository))
        }
        return models
    }
    
    private lazy var placeholder_image: UIImage = {
       return #imageLiteral(resourceName: "user_placeholder")
    }()
    func fill(cell: RepositorySearchCell) {
        cell.repositoryView?.titleLabel.text = repository.name
        cell.repositoryView?.descriptionLabel.text = repository.description
        cell.repositoryView?.avatarImageView.image = placeholder_image
        if let avatarImage = avatar {
            cell.repositoryView?.avatarImageView.image = avatarImage
        }
        else {
            DispatchQueue.global(qos: .background).async { [weak self, weak cell] in
                if let avatarUrlString = self?.repository.owner.avatarUrl, let avatarUrl = URL(string: avatarUrlString) {
                    let data = try? Data(contentsOf: avatarUrl)
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self?.avatar = image
                        DispatchQueue.main.async {
                            //TODO: Check if cell eas reused or subclass UIImageView for download image and reset operation on prepareForReuse
                            cell?.repositoryView?.avatarImageView.image = image
                        }
                    }
                }
            }
        }
    }
}

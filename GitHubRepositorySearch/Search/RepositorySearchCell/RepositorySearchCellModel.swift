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
    var avatar: UIImage? //Stores thumbnail 50x50
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
        cell.repositoryView?.fill(with: self, highlightWords: true)
    }
}

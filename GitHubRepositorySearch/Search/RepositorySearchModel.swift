//
//  RepositorySearchModel.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 18/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import Foundation

class RepositrySearchModelImplementation: RepositorySearchModel {

    func search(query: String, success: @escaping (([GithubRepository]) -> ()), failure: @escaping ((Error?) -> ())) {
        provider.loadSearchResults(for: query, success: { [weak self](result) in
            self?.repositories = result.items
            self?.totalCount = result.totalCount
            success(result.items)
        }) { (error) in
            failure(error)
        }
    }
    
    
    private var repositories: [GithubRepository] = []
    private lazy var provider: GitHubApiProvider = {
       return GitHubApiProvider()
    }()
    var totalCount = 0
//    weak var delegate: RepositorySearchModelDelegate?
    
    func numberOfLoadedItems() -> Int {
        return self.totalCount
    }
}

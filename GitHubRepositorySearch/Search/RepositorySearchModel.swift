//
//  RepositorySearchModel.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 18/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import Foundation

class RepositrySearchModel: RepositorySearchModelProtocol {

    func search(query: String, success: @escaping (([GithubRepository]) -> ()), failure: @escaping ((Error?) -> ())) {
        provider.loadSearchResults(for: query, success: { (result) in
            success(result.items)
        }) { (error) in
            failure(error)
        }
    }
    
    private lazy var provider: GitHubApiProvider = {
       return GitHubApiProvider()
    }()
    
}

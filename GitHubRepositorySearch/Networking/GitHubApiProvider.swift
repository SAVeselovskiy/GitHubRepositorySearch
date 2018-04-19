//
//  GitHubApiProvider.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 18/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import Foundation

typealias RepositorySearchSuccessClosure = (GithubSearchResult) -> ()
typealias RepositorySearchFailClosure = (Error?) -> ()

struct GithubSearchResult: Decodable {
    let totalCount: Int
    let items: [GithubRepository]
}

struct ReposytoryOwner: Decodable {
    let id: Int
    let avatarUrl: String?
}

struct GithubRepository: Decodable {
    let id: Int
    let name: String
    let description: String?
    let owner: ReposytoryOwner
}

class GitHubApiProvider {
    private lazy var backendProvider: BackendProvider = {
        return BackendProvider()
    }()
    
    func loadSearchResults(for searchRequest: String,
                           success: @escaping(RepositorySearchSuccessClosure),
                           failure: @escaping(RepositorySearchFailClosure)
        ) {
        var processedSearchRequest = ""
        for component in searchRequest.split(separator: " ") {
            if processedSearchRequest.count == 0 {
                processedSearchRequest = String(component)
            } else {
                processedSearchRequest += "+\(String(component))"
            }
        }
        let query = "/search/repositories?q=\(processedSearchRequest)"
        backendProvider.executeRecuest(query: query,
                                       method: .GET,
                                       success: success,
                                       failure: failure)
    }
}

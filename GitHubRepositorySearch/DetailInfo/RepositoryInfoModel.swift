//
//  RepositoryInfoModel.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 23/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import Foundation

protocol RepositoryInfoModelProtocol {
    func loadReadme(for repository: GithubRepository,
                    success: @escaping (RepositoryReadme) -> (),
                    failure: @escaping RepositoryFailClosure)
    func loadLanguages(for repository: GithubRepository,
                       success: @escaping (RepositoryLanguageList) -> (),
                       failure: @escaping RepositoryFailClosure)
    func cancelOperations()
}

class RepositoryInfoModel: RepositoryInfoModelProtocol {
    
    private lazy var provider: GitHubApiProvider = {
        return GitHubApiProvider()
    }()
    
    func loadReadme(for repository: GithubRepository,
                    success: @escaping (RepositoryReadme) -> (),
                    failure: @escaping RepositoryFailClosure) {
        provider.loadReadme(for: repository, success: success, failure: failure)
    }
    
    func loadLanguages(for repository: GithubRepository,
                       success: @escaping (RepositoryLanguageList) -> (),
                       failure: @escaping RepositoryFailClosure) {
        provider.loadLanguages(for: repository, success: success, failure: failure)
    }
    
    func cancelOperations() {
        provider.cancelOperations()
    }
}

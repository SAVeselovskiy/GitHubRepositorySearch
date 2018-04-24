//
//  GitHubApiProvider.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 18/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import Foundation
typealias RepositorySearchSuccessClosure = (GithubSearchResult) -> ()
typealias RepositoryFailClosure = (Error?) -> ()

struct RepositoryReadme: Decodable {
    let encoding: String
    let name: String
    var content: String
    
    init(from readme: RepositoryReadme) {
        self.encoding = readme.encoding
        self.content = readme.content
        self.name = readme.name
    }
}

struct RepositoryLanguage: TagCloudObject {
    let name: String
    let weight: Double
    
    init(name: String, weight: Double) {
        self.name = name
        self.weight = weight
    }
}

struct RepositoryLanguageList {
    let languages: [RepositoryLanguage]
    
    init(languages: [String: Any]) {
        var sum = 0
        for name in languages.keys {
            if let weight = languages[name] as? Int {
                sum += weight
            }
        }
        var languageObjects = [RepositoryLanguage]()
        for name in languages.keys {
            if let weight = languages[name] as? Int {
                languageObjects.append(RepositoryLanguage(name: name, weight: Double(weight)/Double(sum)))
            }
        }
        self.languages = languageObjects
    }
}

struct GithubSearchResult: Decodable {
    let totalCount: Int
    let items: [GithubRepository]
}

struct RepositoryOwner: Decodable {
    let id: Int
    let login: String
    let avatarUrl: String?
}

struct GithubRepository: Decodable {
    let id: Int
    let name: String
    let description: String?
    let owner: RepositoryOwner
}

class GitHubApiProvider {
    private let provider: ServerProvider
    
    init(provider: ServerProvider = BackendProvider()) {
        self.provider = provider 
    }
    
    func cancelOperations() {
        provider.cancelAllTasks()
    }
    
    func loadSearchResults(for searchRequest: String,
                           success: @escaping(RepositorySearchSuccessClosure),
                           failure: @escaping(RepositoryFailClosure)
        ) {
        var processedSearchRequest = ""
        for component in searchRequest.split(separator: " ") {
            if processedSearchRequest.count == 0 {
                processedSearchRequest = String(component)
            } else {
                processedSearchRequest += "+\(String(component))"
            }
        }
        let path = "/search/repositories"
        let queryItem = URLQueryItem(name: "q", value: "\(processedSearchRequest)")
        provider.executeObjectRequest(path: path, queryItems: [queryItem],
                                       method: .GET,
                                       success: success,
                                       failure: failure)
    }
    
    func loadLanguages(for repository: GithubRepository,
                       success:@escaping (RepositoryLanguageList)->(),
                       failure: @escaping RepositoryFailClosure) {
        let path = "/repos/\(repository.owner.login)/\(repository.name)/languages"
        provider.executeJSONRequest(path: path, queryItems: [], method: .GET, success: { (dictionary) in
            success(RepositoryLanguageList(languages: dictionary))
        }, failure: failure)
    }
    
    func loadReadme(for repository: GithubRepository,
                    success:@escaping (RepositoryReadme)->(),
                    failure: @escaping RepositoryFailClosure) {
        let path = "/repos/\(repository.owner.login)/\(repository.name)/readme"
        let successBlock: (RepositoryReadme) -> () = { readme in
            let decodedContent = readme.content.base64Decoded()
            if let content = decodedContent {
                var mutableReadme = RepositoryReadme(from: readme)
                mutableReadme.content = content
                success(mutableReadme)
            } else {
                failure(NSError(domain: "VSNetworkDomain", code: -103, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Incorrect reponse encoding", comment: "")]))
            }
        }
        provider.executeObjectRequest(path: path, queryItems: [], method: .GET, success: successBlock, failure: failure)
    }
    
}

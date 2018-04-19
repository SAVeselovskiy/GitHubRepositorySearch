//
//  RepositorySearchPresenter.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 18/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

protocol RepositorySearchViewProtocol {
    func updateData()
}

protocol RepositorySearchModel: class {
    func search(query: String,
                success: @escaping(([GithubRepository]) -> ()),
                failure: @escaping(RepositorySearchFailClosure))
    func numberOfLoadedItems() -> Int
}

protocol RepositorySearchPresenter: class, UITableViewDataSource, UISearchBarDelegate {
    func handleItemSelection(at index: Int)
    func viewDidLoad()
    func reloadData()
}

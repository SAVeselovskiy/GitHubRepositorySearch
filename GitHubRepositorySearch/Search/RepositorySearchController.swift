//
//  RepositorySearchController.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 18/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

protocol RepositorySearchModelProtocol: class {
    func search(query: String,
                success: @escaping(([GithubRepository]) -> ()),
                failure: @escaping(RepositorySearchFailClosure))
}

class RepositorySearchController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cellsModels: [RepositorySearchCellModel] = []
    
    private lazy var model: RepositorySearchModelProtocol = {
        return RepositrySearchModel()
    }()
    
    private var keyboardShowObserver: NSObjectProtocol?
    private var keyboardHideObserver: NSObjectProtocol?
    
    private var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RepositorySearchCell.self, forCellReuseIdentifier: "RepositoryCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        searchBar.delegate = self
        keyboardShowObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            if let frame = endFrame {
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, frame.size.height, 0)
            }
        }
        keyboardHideObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        if let observer = keyboardShowObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = keyboardHideObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    @objc func search() {
        searchBar.resignFirstResponder()
        if let searchQuery = searchBar.text, searchQuery != ""{
            model.search(query: searchQuery, success: { [weak self](repositories) in
                self?.cellsModels = RepositorySearchCellModel.parse(repositories: repositories)
                self?.tableView.reloadData()
            }) { [weak self] (error) in
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        if let timer = searchTimer, timer.isValid {
            timer.invalidate()
        }
    }
}


//MARK: - TableView DataSource
extension RepositorySearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath)
        if let repositoryCell = cell as? RepositorySearchCell {
            //bind data
            cellsModels[indexPath.row].fill(cell: repositoryCell)
        }
        return cell
    }
}
//MARK: - TableView Delegate
extension RepositorySearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - SearchBar Delegate
extension RepositorySearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let timer = searchTimer, timer.isValid {
            timer.invalidate()
        }
        //TODO: check performance, cause it uses on current run loop
        searchTimer = Timer.scheduledTimer(timeInterval: 0.7,
                                           target: self,
                                           selector: #selector(search),
                                           userInfo: nil,
                                           repeats: false)
    }
}
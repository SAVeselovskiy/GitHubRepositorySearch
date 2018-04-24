//
//  RepositorySearchView.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 20/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

class RepositorySearchView: UIView {
    let tableView: UITableView
    let searchBar: VSSearchBar
    
    init () {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "VSSearchBar", bundle: bundle)
        let view = nib.instantiate(withOwner: nil, options: nil).first as? VSSearchBar
        if let searchBarView = view {
            searchBar = searchBarView
            searchBar.translatesAutoresizingMaskIntoConstraints = false
        } else {
            fatalError("Nib didnt load")
        }
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func commonInit() {
        self.addSubview(tableView)
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: tableView, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: tableView, attribute: .right, multiplier: 1.0, constant: 0.0)
            ])
        
        self.addSubview(searchBar)
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: searchBar, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: searchBar, attribute: .right, multiplier: 1.0, constant: 0.0)
            ])
        
        self.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        searchBar.addConstraint(NSLayoutConstraint(item: searchBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0))
    }

}

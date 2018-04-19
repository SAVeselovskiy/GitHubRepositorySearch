//
//  RepositorySearchController.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 18/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

class RepositorySearchController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var provider: GitHubApiProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        provider = GitHubApiProvider()
        provider?.loadSearchResults(for: "Tag Cloud iOS", success: { (results) in
            print(results)
        }, failure: { [weak self] (error) in
            var loadingError = error
            if error == nil {
                loadingError = NSError(domain: "VSSearchList", code: 500, userInfo: nil)
            }
            self?.present(UIAlertController(title: NSLocalizedString("Error", comment: ""), message: loadingError?.localizedDescription, preferredStyle: .alert), animated: true, completion: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

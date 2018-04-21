//
//  RepositoryInfoController.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 21/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

class RepositoryInfoController: UIViewController {
    @IBOutlet weak var infoView: RepositoryMainInfoView!
    var repositoryInfo: GithubRepository?
    var mainInfoModel: RepositorySearchCellModel?
    
    static func instantiateInfoController(with repoInfo: GithubRepository?, mainInfoModel: RepositorySearchCellModel?) -> UIViewController {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailInfoViewController")
        if let repositoryController = controller as? RepositoryInfoController {
            repositoryController.repositoryInfo = repoInfo
            repositoryController.mainInfoModel = mainInfoModel
        }
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.layer.cornerRadius = 8.0
        if let infoModel = mainInfoModel {
            infoView.fill(with: infoModel)
        }
        // Do any additional setup after loading the view.
        
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

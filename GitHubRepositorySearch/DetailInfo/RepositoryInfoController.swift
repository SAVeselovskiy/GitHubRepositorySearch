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

    @IBOutlet weak var readmeLabel: LabelWithLoadingIndicator!
    @IBOutlet weak var tagCloudLabel: LabelWithLoadingIndicator!
    
    

    var repositoryInfo: GithubRepository?
    var mainInfoModel: RepositorySearchCellModel?
    lazy var model: RepositoryInfoModelProtocol = {
       return RepositoryInfoModel()
    }()
    
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
        readmeLabel.layer.cornerRadius = 8.0
        tagCloudLabel.layer.cornerRadius = 8.0
        
        if let infoModel = mainInfoModel {
            infoView.fill(with: infoModel, highlightWords: false)
        }
        
        loadTagCloud()
        loadReadme()
        
        // Do any additional setup after loading the view.
        
    }
    
    func loadReadme() {
        guard let repoInfo = repositoryInfo else {return}
        readmeLabel.showActivityIndicator(true)
        model.loadReadme(for: repoInfo, success: { [weak self](readme) in
            self?.readmeLabel.text = readme.content
            self?.readmeLabel.showActivityIndicator(false)
            }, failure: { [weak self](error) in
                self?.readmeLabel.showActivityIndicator(false)
                if let loadError = error as NSError? {
                    if loadError.code != -999 { //canceled
                        self?.readmeLabel.showReloadView { [weak self] in
                            self?.loadReadme()
                        }
                    }
                }
        })
    }
    
    func loadTagCloud() {
        guard let repoInfo = repositoryInfo else {return}
        tagCloudLabel.showActivityIndicator(true)
        model.loadLanguages(for: repoInfo, success: { [weak self](list) in
            self?.tagCloudLabel.showActivityIndicator(false)
            self?.tagCloudLabel.setTextObject(list.languages)
            }, failure: { [weak self](error) in
                self?.tagCloudLabel.showActivityIndicator(false)
                if let loadError = error as NSError? {
                    if loadError.code != -999 { //canceled
                        self?.tagCloudLabel.showReloadView { [weak self] in
                            self?.loadTagCloud()
                        }
                    }
                }
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.readmeLabel.resizeLabel(for: size.width) //dirty hacks
        self.tagCloudLabel.resizeLabel(for: size.width)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        model.cancelOperations()
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

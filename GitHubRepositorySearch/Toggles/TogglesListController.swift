//
//  TogglesListController.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 25/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

enum FeatureToggles: Int {
    case errorGenerator
    
    func toggleKey() -> String {
        switch self {
        case .errorGenerator:
            return "ErrorGeneratorToggleKey"
        }
    }
    
    func toggleName() -> String {
        switch self {
        case .errorGenerator:
            return "Error Generator"
        }
    }
    
    static func count() -> Int {
        var count = 0
        while let _ = FeatureToggles(rawValue: count) {
            count += 1
        }
        return count
    }
}

class TogglesListController: UIViewController {
    var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView?.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        addTableView(tableView: tableView)
        tableView?.dataSource = self
        tableView?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    private func addTableView(tableView: UITableView?) {
        guard let tableView = tableView else {
            return
        }
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
                NSLayoutConstraint(item: self.view, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self.view, attribute: .left, relatedBy: .equal, toItem: tableView, attribute: .left, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self.view, attribute: .right, relatedBy: .equal, toItem: tableView, attribute: .right, multiplier: 1.0, constant: 0.0)
            ])
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
    
    @objc func switchDidChange(switcher: UISwitch) {
        guard let toggle = FeatureToggles(rawValue: switcher.tag) else { return }
        UserDefaults.standard.set(switcher.isOn, forKey: toggle.toggleKey())
    }

}

extension TogglesListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeatureToggles.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToggleCell")
        cell.textLabel?.text = FeatureToggles(rawValue: indexPath.row)?.toggleName()
        if cell.accessoryView == nil {
            let switcher = UISwitch()
            switcher.tag = indexPath.row
            switcher.addTarget(self, action: #selector(switchDidChange(switcher:)), for: .valueChanged)
            cell.accessoryView = switcher
        }
        if let switcher = cell.accessoryView as? UISwitch {
            switcher.tag = indexPath.row
            if let key = FeatureToggles(rawValue: indexPath.row)?.toggleKey() {
                switcher.isOn = UserDefaults.standard.bool(forKey: key)
            } else {
                switcher.isOn = false
            }
        }
        
        return cell
    }
}

extension TogglesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

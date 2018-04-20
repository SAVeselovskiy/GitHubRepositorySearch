//
//  RepositorySearchCell.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 19/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

class RepositorySearchCell: UITableViewCell {
    var repositoryView: RepositoryMainInfoView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // code common to all your cells goes here
        if repositoryView == nil {
            commonInit()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let view = Bundle.main.loadNibNamed("RepositoryMainInfoView", owner: self, options: nil)?[0] as? UIView
        if let repositoryView = view as? RepositoryMainInfoView{
            repositoryView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(repositoryView)
            contentView.addConstraints([
                NSLayoutConstraint(item: contentView,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: repositoryView,
                                   attribute: .top,
                                   multiplier: 1.0,
                                   constant: 0.0),
                NSLayoutConstraint(item: contentView,
                                   attribute: .left,
                                   relatedBy: .equal,
                                   toItem: repositoryView,
                                   attribute: .left,
                                   multiplier: 1.0,
                                   constant: 0.0),
                NSLayoutConstraint(item: contentView,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: repositoryView,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: 0.0),
                NSLayoutConstraint(item: contentView,
                                   attribute: .right,
                                   relatedBy: .equal,
                                   toItem: repositoryView,
                                   attribute: .right,
                                   multiplier: 1.0,
                                   constant: 0.0)
                ])
            self.repositoryView = repositoryView
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

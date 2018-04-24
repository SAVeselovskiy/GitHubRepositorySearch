//
//  RepositoryMainInfoView.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 19/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

class RepositoryMainInfoView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var avatarImageView: DownloadImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("RepositoryMainInfoView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: 0.0)
            ])
    }
    
    func fill(with model: RepositorySearchCellModel, highlightWords: Bool) {
        if highlightWords {
            titleLabel.setText(model.repository.name, keywords: model.keywords)
            descriptionLabel.setText(model.repository.description, keywords: model.keywords)
        } else {
            titleLabel.setText(model.repository.name, keywords: [])
            descriptionLabel.setText(model.repository.description, keywords: [])
        }
        
        avatarImageView.image = #imageLiteral(resourceName: "user_placeholder")
        if let avatarImage = model.avatar {
            avatarImageView.image = avatarImage
        }
        else {
            if let avatarUrlString = model.repository.owner.avatarUrl, let avatarUrl = URL(string: avatarUrlString) {
                avatarImageView.downloadImage(url: avatarUrl, rounded: true) { (image) in
                    model.avatar = image
                }
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

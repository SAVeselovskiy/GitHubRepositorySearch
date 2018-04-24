//
//  LabelWithLoadingIndicator.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 23/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

class LabelWithLoadingIndicator: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var label: TagCloudLabel!
    var heightConstraint: NSLayoutConstraint!
    
    private lazy var reloadView: UIView = {
        return createFailLoadingView()
    }()
    
    var reloadBlock: (() -> ())?
    
    func showReloadView(didTap: @escaping () -> ()) {
        self.label.isHidden = true
        self.reloadBlock = didTap
        self.addSubview(reloadView)
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: reloadView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: reloadView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: reloadView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            ])
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(executeReloadBlock))
        tapGestureRecognizer.numberOfTapsRequired = 1
        reloadView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func executeReloadBlock() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.backgroundColor = UIColor.lightGray
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                self.contentView.backgroundColor = UIColor.white
                self.reloadView.removeFromSuperview()
                self.reloadBlock?()
            })
        }
        
    }
    
    func setTextObject(_ objects: [TagCloudObject]) {
        self.label.setTextObject(objects)
        self.resizeLabel()
    }
    
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
            resizeLabel()
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _ = Bundle.main.loadNibNamed("LabelWithLoadingIndicator", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: 0.0)
            ])
        activityIndicator.isHidden = true
        heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        self.addConstraint(heightConstraint)
    }
    
    func resizeLabel(for width: CGFloat? = nil) {
        var labelWidth = label.bounds.width
        if let viewWidth = width {
            labelWidth = viewWidth - label.frame.origin.x * 2 - self.frame.origin.x * 2
        }
        let size = label.textRect(forBounds: CGRect(x: 0.0, y: 0.0, width: labelWidth, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines: 0)
        heightConstraint.constant = size.size.height + label.frame.origin.y * 2
        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    func showActivityIndicator(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            label.isHidden = true
        }
        else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            label.isHidden = false
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

extension LabelWithLoadingIndicator {
    func createFailLoadingView() -> UIView {
        let mainView = UIView(frame: self.bounds)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        let reloadLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        reloadLabel.text = NSLocalizedString("Error", comment: "")
        reloadLabel.textColor = UIColor.darkText
        reloadLabel.translatesAutoresizingMaskIntoConstraints = false
        reloadLabel.backgroundColor = UIColor.clear
        mainView.addSubview(reloadLabel)
        mainView.addConstraints([
            NSLayoutConstraint(item: mainView, attribute: .top, relatedBy: .equal, toItem: reloadLabel, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: mainView, attribute: .bottom, relatedBy: .equal, toItem: reloadLabel, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: mainView, attribute: .left, relatedBy: .equal, toItem: reloadLabel, attribute: .left, multiplier: 1.0, constant: 0.0)
            ])
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "ic_reload")
        imageView.backgroundColor = UIColor.clear
        mainView.addSubview(imageView)
        imageView.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25.0),
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25.0)
            ])
        mainView.addConstraints([
            NSLayoutConstraint(item: mainView, attribute: .centerY, relatedBy: .equal, toItem: imageView, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: mainView, attribute: .right, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1.0, constant: 0.0)
            ])
        mainView.addConstraint(NSLayoutConstraint(item: reloadLabel, attribute: .right, relatedBy: .equal, toItem: imageView, attribute: .left, multiplier: 1.0, constant: -10.0))
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return mainView
    }
}

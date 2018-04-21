//
//  VSSearchBar.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 20/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

protocol VSSearchBarDelegate: class {
    func searchBarDidChange(text: String?)
    func didTapSearchButton()
}

class VSSearchBar: UIView {
    weak var delegate: VSSearchBarDelegate?
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet var contentView: UIView!
    
    
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _ = Bundle.main.loadNibNamed("VSSearchBar", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
                NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: 0.0)
            ])
        activityIndicator.isHidden = true
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        textField.returnKeyType = .search
        textField.delegate = self
        searchButton.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        searchButton.setTitle(NSLocalizedString("Search", comment: ""), for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func showActivityIndicator(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            searchButton.isHidden = true
        }
        else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            searchButton.isHidden = false
        }
    }
    
    @objc func didPressButton() {
        self.delegate?.didTapSearchButton()
    }
    
    @objc private func didChangeText() {
        self.delegate?.searchBarDidChange(text: textField.text)
    }
}

extension VSSearchBar: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.delegate?.didTapSearchButton()
        return false
    }
}

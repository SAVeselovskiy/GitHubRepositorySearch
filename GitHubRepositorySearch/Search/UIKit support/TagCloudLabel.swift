//
//  TagCloudLabel.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 23/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

protocol TagCloudObject {
    var name: String { get }
    var weight: Double { get }
}

class TagCloudLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private lazy var colors: [UIColor] = {
        return [UIColor.red, UIColor.green, UIColor.blue, UIColor.brown]
    }()
    
    func setTextObject(_ objects: [TagCloudObject]){
        let text = NSMutableAttributedString(string: "")
        var shuffledObjects = objects
        shuffledObjects.shuffle()
        colors.shuffle()
        var i = 0
        for object in shuffledObjects {
            let attributedString = NSAttributedString(string: object.name + " ", attributes: [NSAttributedStringKey.font: self.font(for: object.weight), NSAttributedStringKey.foregroundColor: colors[i % colors.count]])
            text.append(attributedString)
            i += 1
        }
        self.attributedText = text
        
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func font(for weight: Double) -> UIFont {
        if weight < 0.2 {
            return UIFont.systemFont(ofSize: 15.0)
        } else if weight < 0.4 {
            return UIFont.systemFont(ofSize: 18.0)
        } else if weight < 0.6 {
            return UIFont.systemFont(ofSize: 21.0)
        } else if weight > 0.6 {
            return UIFont.systemFont(ofSize: 24.0)
        }
        return UIFont.systemFont(ofSize: 15.0)
    }

}

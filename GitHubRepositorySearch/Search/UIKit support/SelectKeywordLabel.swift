//
//  SelectKeywordLabel.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 21/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

extension UILabel {
    func setText(_ text: String?, keywords: [String]?) {
        //поиск элементов в тексте
        //для каждой найденной подстроки назначить атрибут
        guard let labelText = text, let textKeywords = keywords, textKeywords.count != 0 else {
            self.text = text
            return
        }
        let attributedString = NSMutableAttributedString(string: labelText)
        for keyword in textKeywords {
            let indices = labelText.indicesOf(string: keyword)
            for index in indices {
                let attrRange = NSMakeRange(index, keyword.count)
                let color = UIColor(red: 255.0/255.0, green: 163.0/255.0, blue: 0.0, alpha: 0.47)
                attributedString.addAttribute(NSAttributedStringKey.backgroundColor, value: color, range: attrRange)
            }
        }
        self.attributedText = attributedString
    }
}


extension String {
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        let lowercaseString = self.lowercased()
        let lowercaseKeyword = string.lowercased()
        
        while searchStartIndex < self.endIndex,
            let range = lowercaseString.range(of: lowercaseKeyword, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
}

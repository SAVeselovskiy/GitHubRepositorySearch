//
//  UIImageExtension.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 20/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

extension UIImage {
    func resizedImage(newSize: CGSize) -> UIImage? {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

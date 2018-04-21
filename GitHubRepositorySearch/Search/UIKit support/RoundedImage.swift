//
//  RoundedImage.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 22/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

extension UIImage {
    func roundedImage(cornerRadius: Double) -> UIImage? {
        let frame = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let bezierPath = UIBezierPath(roundedRect: frame, cornerRadius: CGFloat(cornerRadius))
        bezierPath.addClip()
        self.draw(in: frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

//
//  StringEncoding.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 22/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import Foundation

extension String {
    
    func base64Encoded() -> String? {
        let plainData = data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString()
        return base64String
    }
    
    func base64Decoded() -> String? {
        let decodedData = Data(base64Encoded: self, options: .ignoreUnknownCharacters)
        if let data = decodedData {
            let decodedString = String(data: data, encoding: .utf8)
            return decodedString
        }
        return nil
    }
}

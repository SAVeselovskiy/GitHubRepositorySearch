//
//  UIImageView+ImageDownload.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 21/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

class DownloadImageView: UIImageView {
    var loadOperation: Operation?
    
    func stopOperation() {
        self.loadOperation?.cancel()
    }
    
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> ()){
        self.loadOperation = ImageDownloadOperation(url: url, completion: { (loadedImage, error) in
            DispatchQueue.main.async { [weak self] in
                self?.image = loadedImage
                completion(loadedImage)
            }
        })
        self.loadOperation?.start()
    }
}

class ImageDownloadOperation: Operation {
    enum VSOperationState {
        case ready
        case executing
        case canceled
        case finished
    }
    
    let imageUrl: URL
    let completion: (UIImage?, Error?)->()
    var currentState: VSOperationState
    
    init(url: URL, completion: @escaping (UIImage?, Error?) -> ()) {
        currentState = .ready
        imageUrl = url
        self.completion = completion
    }
    
    override func start() {
        if isCancelled {
            self.currentState = .canceled
        } else if isReady {
            do {
                let data = try Data(contentsOf: imageUrl)
                let image = UIImage(data: data)
                let resizedAvatar = image?.resizedImage(newSize: CGSize(width: 50, height: 50))
                completion(resizedAvatar, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    override var isReady: Bool {
        get {
            return super.isReady && currentState == .ready
        }
    }
    
    override var isExecuting: Bool {
        get {
            return currentState == .executing
        }
    }
    
    override var isFinished: Bool {
        get {
            return currentState == .finished
        }
    }
    
    override var isAsynchronous: Bool {
        get {
            return true
        }
    }
}

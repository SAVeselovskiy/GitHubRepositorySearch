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
    static let imageSize = 50.0
    
    func stopOperation() {
        self.loadOperation?.cancel()
    }
    
    func downloadImage(url: URL, rounded: Bool, completion: @escaping (UIImage?) -> ()){
        self.loadOperation = ImageDownloadOperation(url: url, completion: { (loadedImage, error) in
            var resultImage = loadedImage
            if rounded {
               resultImage = loadedImage?.roundedImage(cornerRadius: DownloadImageView.imageSize/2)
            }
            DispatchQueue.main.async { [weak self] in
                self?.image = resultImage
                completion(resultImage)
            }
        })
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.loadOperation?.start()
        }
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
                let resizedAvatar = image?.resizedImage(newSize: CGSize(width: DownloadImageView.imageSize,
                                                                        height: DownloadImageView.imageSize))
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

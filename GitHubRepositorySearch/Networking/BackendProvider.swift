//
//  BackendProvider.swift
//  GitHubRepositorySearch
//
//  Created by Сергей Веселовский on 17/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "Delete"
}

enum RequestError: Int {
    case incorrectResponseData = -103
    case incorrectURLAddress = -101
    case randomError = -1
    
    static func error(with code: RequestError) -> NSError {
        switch code {
        case .incorrectURLAddress:
            return NSError(domain: "VSNetworkDomain",
                           code: RequestError.incorrectURLAddress.rawValue,
                           userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Incorrect URL address",
                                                                                    comment: "")])
        case .incorrectResponseData:
            return NSError(domain: "VSNetworkDomain",
                           code: RequestError.incorrectResponseData.rawValue,
                           userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Incorrect response data", comment: "")])
        case .randomError:
            return NSError(domain: "VSNetworkDomain",
                           code: RequestError.randomError.rawValue,
                           userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Random generated error", comment: "")])
        }
    }
}

protocol ServerProvider {
    init(_ hostName: String?)
    func executeObjectRequest<T: Decodable>(path: String, queryItems: [URLQueryItem], method: HttpMethod,
                                      success: @escaping((T)->()),
                                      failure: @escaping((Error?)->()))
    
    func executeJSONRequest(path: String, queryItems: [URLQueryItem], method: HttpMethod,
                            success: @escaping(([String: Any])->()),
                            failure: @escaping((Error?)->()))
    
    func cancelAllTasks()
}

class BackendProvider: ServerProvider {
    private static let defaultHost = "https://api.github.com"
    let hostName: String
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration)
    }()
    
    required init(_ hostName: String? = BackendProvider.defaultHost) {
        self.hostName = hostName ?? BackendProvider.defaultHost
    }
    
    func executeObjectRequest<T: Decodable>(path: String, queryItems: [URLQueryItem], method: HttpMethod,
                        success: @escaping((T)->()),
                        failure: @escaping((Error?)->())) {
        self.executeRequest(path: path, queryItems: queryItems, method: method, success: { [weak self](data, httpResponse) in
            if let mimeType = httpResponse.mimeType, mimeType == "application/json" {
                self?.decodeJSON(data: data, success: success, failure: failure)
            }
        }, failure: failure)
    }
    
    func executeJSONRequest(path: String, queryItems: [URLQueryItem], method: HttpMethod,
                            success: @escaping(([String: Any])->()),
        failure: @escaping((Error?)->())) {
        self.executeRequest(path: path, queryItems: queryItems, method: method, success: { (data, httpResponse) in
            if let mimeType = httpResponse.mimeType, mimeType == "application/json" {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionaryJSON = jsonObject as? [String: Any] {
                        success(dictionaryJSON)
                    } else {
                        failure(RequestError.error(with: .incorrectResponseData))
                    }
                } catch {
                    failure(error)
                }
            }
            }, failure: failure)
    }
    
    func cancelAllTasks() {
        session.invalidateAndCancel()
    }
    
    private func executeRequest(path: String, queryItems: [URLQueryItem], method: HttpMethod,
                        success: @escaping((Data, HTTPURLResponse)->()),
                        failure: @escaping((Error?)->())) {
        var urlComponents = URLComponents(string: self.hostName)
        urlComponents?.path = path
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            let clientError = RequestError.error(with: .incorrectURLAddress)
            failure(clientError)
            return
        }
        let needRandomError = UserDefaults.standard.bool(forKey: FeatureToggles.errorGenerator.toggleKey())
        if  needRandomError {
            if let randomError = generateError(oneOf: 2) {
                failure(randomError)
                return
            }
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        print("\n\n\(request.debugDescription)\n\n")

        let task = session.dataTask(with: request) { [weak self](data, response, error) in
            if let response = response {
                print("\n\n\(response.debugDescription)\n\n")
            }
            if let error = error {
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    self?.handleServerError(response: response, completion: failure)
                    return
            }
            if let data = data {
                DispatchQueue.main.async {
                    success(data, httpResponse)
                }
            } else {
                failure(RequestError.error(with: .incorrectResponseData) as Error)
            }
        }
        task.resume()
    }

}

extension BackendProvider {
    func decodeJSON<T: Decodable>(data: Data, success: @escaping((T)->()),
                                  failure: @escaping((Error?)->())) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let object = try decoder.decode(T.self, from: data)
            print("success")
            success(object)
        } catch {
            failure(error)
        }
    }
    
    
    private func handleServerError(response: URLResponse?, completion: (Error?)->()) {
        let httpResponse = response as? HTTPURLResponse
        let statusCode = httpResponse?.statusCode ?? 500
        let serverError = NSError(domain: "VSBackendDomain", code: statusCode, userInfo: [NSLocalizedDescriptionKey : HTTPURLResponse.localizedString(forStatusCode: statusCode)])
        completion(serverError as Error)
    }
}

extension BackendProvider {
    func generateError(oneOf attempts: Int) -> Error? {
        let random = Int(arc4random_uniform(100))
        if random % attempts != 0 {
            return RequestError.error(with: .randomError)
        }
        
        return nil
    }
}

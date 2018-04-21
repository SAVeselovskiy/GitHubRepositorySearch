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

protocol Parsable {
    init()
    func parse(_ map: [String: Any])
}

protocol ServerProvider {
    init(_ hostName: String?)
    func executeRecuest<T: Decodable>(path: String, queryItems: [URLQueryItem], method: HttpMethod,
                                      success: @escaping((T)->()),
                                      failure: @escaping((Error?)->()))
}

class BackendProvider: ServerProvider {
    private static let defaultHost = "https://api.github.com"
    let hostName: String
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }()
    
    required init(_ hostName: String? = BackendProvider.defaultHost) {
        self.hostName = hostName ?? BackendProvider.defaultHost
    }
    
    func executeRecuest<T: Decodable>(path: String, queryItems: [URLQueryItem], method: HttpMethod,
                        success: @escaping((T)->()),
                        failure: @escaping((Error?)->())) {
        var urlComponents = URLComponents(string: self.hostName)
        urlComponents?.path = path
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            let clientError = NSError(domain: "VSNetworkDomain",
                                      code: -101,
                                      userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Incorrect URL address",
                                                                                               comment: "")])
            failure(clientError)
            return
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
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                let data = data {
                    DispatchQueue.main.async { [weak self] in
                        self?.decodeJSON(data: data, success: success, failure: failure)
                    }
            }
        }
        task.resume()
    }
    
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
    
    
    func handleServerError(response: URLResponse?, completion: (Error?)->()) {
        let httpResponse = response as? HTTPURLResponse
        let statusCode = httpResponse?.statusCode ?? 500
        let serverError = NSError(domain: "VSBackendDomain", code: statusCode, userInfo: [NSLocalizedDescriptionKey : HTTPURLResponse.localizedString(forStatusCode: statusCode)])
        completion(serverError as Error)
    }

}
